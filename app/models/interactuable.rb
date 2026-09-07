class Interactuable < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    has_many :tagged_users, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :reposts, dependent: :destroy
    has_many_attached :photos

  ## VALIDATIONS
  
    validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
    validates :type, presence: true
  
  ## SCOPES

    scope :register, -> { where(type: "Register") }
    scope :publication, -> { where(type: "Publication") }

  ## CLASS METHODS

  public

    def self.viewables(user)
      if user.present?
        #Remove Interactuables from users than have BLOCKED ME
        int = Interactuable.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove Interactuables from users than I HAVE BLOCKED
        int.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        Interactuable.all
      end
    end

  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

    def register?
      self.type == "Register"
    end

    def publication?
      self.type == "Publication"
    end

    def photo
      if register?
        return event.photo
      elsif publication?
        return photos.first
      end
    end

end