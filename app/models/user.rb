class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## RELATIONSHIPS

    belongs_to :role

    has_many :registers, dependent: :destroy
    has_many :publications, dependent: :destroy
    has_many :future_assistances, dependent: :destroy
    has_one :ubication, dependent: :destroy
    has_many :followings, -> { where(relation_type: 0)  }, class_name: "Relation", foreign_key: :follower_id, dependent: :destroy
    has_many :followers, -> {  where(relation_type: 0) }, as: :followed, class_name: "Relation", dependent: :destroy
    has_many :blocked_users, -> {  where(relation_type: 1) }, class_name: "Relation", foreign_key: :follower_id, dependent: :destroy
    has_many :favorite_artists, dependent: :destroy
    has_many :chat_users, dependent: :destroy
    has_many :chats, through: :chat_users
    has_many :notifications, class_name: "Noticed::Notification", as: :recipient, dependent: :destroy
    has_many :requests, foreign_key: :requester_id #dependent: :destroy, DONT DESTROY
    has_many :likes, dependent: :destroy

    has_one_attached :icon

  ## SCOPES
  
    scope :by_name, ->(query) { where("username ILIKE :q", q: "%#{query}%") } 
    scope :admins, -> { where(role_id: Role.find_by(name: "admin").id) }

  ## VALIDATIONS

    validates :email, :username, presence: true
    validates :email, :username, uniqueness: true
    validates :description, length: { maximum: 500, message: ->(object, data) {"solo permite #{data[:count]} carácteres y has usado #{data[:value].to_s.length} carácteres" }}, allow_nil: true

  ## CLASS METHODS

    def self.viewables(user)
      if user.present?
        #Remove users than have BLOCKED ME
        users = User.where.not(id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove users than I HAVE BLOCKED
        users.where.not(id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        User.all
      end
    end

  ## INSTANCE METHODS

    def admin?
      role.admin?
    end

    def user?
      role.user?
    end
 
    def follows_artist?(artist)
      followings.find_by(followed_id: artist&.id, followed_type: "Artist").present?
    end

     def follows_user?(user)
      followings.find_by(followed_id: user&.id, followed_type: "User").present?
    end

    def blocked_user?(user_id)
      blocked_users.find_by(followed_id: user_id, followed_type: "User").present?
    end

    def favorite_artist?(artist_id)
      favorite_artists.find_by(artist_id: artist_id).present?
    end

    def can_mark_favorite?
      favorite_artists.count < 4
    end

    def follow(user)
      Relation.find_or_create_by!(follower_id: self.id, followed_id: user.id, followed_type: "User", relation_type: 0)
    end

    def unfollow(user)
      Relation.find_by(follower_id: self.id, followed_id: user.id, followed_type: "User", relation_type: 0)&.destroy
    end

    def block(user_id)
      Relation.find_or_create_by!(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 1)
      # destroy followings relations if they exist
      Relation.find_by(follower_id: user_id, followed_id: self.id, followed_type: "User", relation_type: 0)&.destroy
      Relation.find_by(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 0)&.destroy
      # destroy likes between users
      Like.for_user(user_id).for_interactuable_user(self.id).destroy_all
      Like.for_user(self.id).for_interactuable_user(user_id).destroy_all
      # destroy resposts between users
      Repost.for_user(self.id).for_interactuable_user(user_id).destroy_all
      Repost.for_user(self.id).for_interactuable_user(user_id).destroy_all
    end

    def unblock(user_id)
      Relation.find_by!(follower_id: user_id, followed_id: self.id, followed_type: "User", relation_type: 1)&.destroy
    end

    def liked?(interactuable_id)
      Like.find_by(interactuable_id: interactuable_id, user_id: self.id).present?
    end

    def reposted?(interactuable_id)
      Repost.find_by(interactuable_id: interactuable_id, user_id: self.id).present?
    end

    def viewable_chats
      chats.group_chat?
    end

end
