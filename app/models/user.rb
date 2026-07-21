class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## RELATIONSHIPS

    has_many :registered_concerts, dependent: :destroy
    has_many :future_assistances, dependent: :destroy
    has_one :ubication
    has_many :followings, -> { where(relation_type: 0)  }, class_name: "Relation", foreign_key: :follower_id, dependent: :destroy
    has_many :followers, -> {  where(relation_type: 0) }, as: :followed, class_name: "Relation", dependent: :destroy
    has_many :blocked_users, -> {  where(relation_type: 1) }, class_name: "Relation", foreign_key: :follower_id, dependent: :destroy
    has_many :favorite_artists
    has_one_attached :icon

  ## SCOPES
  
    scope :by_name, ->(query) { where("username ILIKE :q", q: "%#{query}%") } 

  ## VALIDATIONS

    validates :email, :username, presence: true
    validates :email, :username, uniqueness: true
    validates :description, length: { maximum: 500, message: ->(object, data) {"solo permite #{data[:count]} carácteres y has usado #{data[:value].to_s.length} carácteres" }}, allow_nil: true

  ## INSTANCE METHODS
 
    def follows_artist?(artist_id)
      followings.find_by(followed_id: artist_id, followed_type: "Artist").present?
    end

     def follows_user?(user_id)
      followings.find_by(followed_id: user_id, followed_type: "User").present?
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

    def follow(user_id)
      Relation.find_or_create_by!(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 0)
    end

    def unfollow(user_id)
      Relation.find_by(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 0)&.destroy
    end

    def block(user_id)
      Relation.find_or_create_by!(follower_id: user_id, followed_id: self.id, followed_type: "User", relation_type: 1)
      # destroy followings relations if the exist
      Relation.find_by(follower_id: user_id, followed_id: self.id, followed_type: "User", relation_type: 0)&.destroy
      Relation.find_by(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 0)&.destroy
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
   


end
