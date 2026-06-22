class RegisteredConcert < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :concert
    has_many_attached :photos

    ## VALIDATIONS

    validates :concert_id, presence: true
    validates :concert_id, uniqueness: { scope: :user_id, message: "Ya has registrado este concierto" }
    validate :photos_limit

    ## SCOPES

    scope :by_artist, ->(artist_id) { left_joins(concert: :artists).where(artists: { id: artist_id }) }

    ## VALIDATION METHODS

    def photos_limit
        if photos.attached? && photos.count > 10
            errors.add(:photos, "10 fotos máximo")
        end
    end

    ## METHODS

    def get_puntuation
        puts self.puntuation
        if self.puntuation.nil?
            self.puntuation = 0
        end
        "★" * self.puntuation + "☆" * (5 - self.puntuation)
    end

end