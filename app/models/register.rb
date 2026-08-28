class Register < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :event

    ## VALIDATIONS

    validates :event_id, presence: true
    validates :event_id, uniqueness: { scope: :user_id, message: "Ya has registrado este evento" }
    validate :photos_limit

    ## SCOPES

    scope :by_artist, ->(artist_id) { left_joins(event: :artists).where(artists: { id: artist_id }) }
    scope :with_review, -> { where.not(review: nil).where("TRIM(review) != ''") }
    scope :by_friends, -> (current_user) { where(user_id: current_user.followings.pluck(:followed_id)) }

    ## VALIDATION METHODS

    def photos_limit
        if photos.attached? && photos.count > 10
            errors.add(:photos, "10 fotos máximo")
        end
    end

  ## CLASS METHODS

    def self.viewables(user)
      if user.present?
        #Remove Registers from users than have BLOCKED ME
        reg = Register.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove Registers from users than I HAVE BLOCKED
        reg.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        Register.all
      end
    end

  ## INSTANCE METHODS

    def get_rating
      rating = self.rating.nil? ? 0 : self.rating
      return "★" * rating
    end

end