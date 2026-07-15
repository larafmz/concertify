class Interactuable < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    has_many :tagged_users
    #has_many :comments TO/DO
    has_many :likes
    #has_many :reposts TO/DO
    has_many_attached :photos

  ## VALIDATIONS
  
    validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
    validates :type, presence: true
    validate :photos_limit
  
  ## SCOPES

    scope :register, -> { where(type: "Register") }
    scope :publication, -> { where(type: "Publication") }

  ## VALIDATION METHODS

    def photos_limit
        if photos.attached? && photos.count > 4
            errors.add(:photos, "4 fotos máximo") #TO/DO en form y show de registro y de concierto/artista
        end
    end

  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

end