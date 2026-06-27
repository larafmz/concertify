class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## RELATIONSHIPS

    has_many :interactuables, dependent: :destroy
    has_one :ubication
    has_many :followings, class_name: "Relation", foreign_key: :follower_id, dependent: :destroy
    has_many :followers, as: :followed, class_name: "Relation", dependent: :destroy

  ## VALIDATIONS

    validates :email, :username, :name, presence: true
    validates :email, :username, uniqueness: true

  ## INSTANCE METHODS
 
    def follows_artist?(artist_id)
      Relation.find_by(follower_id: self.id, followed_id: artist_id, followed_type: "Artist", relation_type: 0).present?
    end

     def follows_user?(user_id)
      Relation.find_by(follower_id: self.id, followed_id: user_id, followed_type: "User", relation_type: 0).present?
    end

end
