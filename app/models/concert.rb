class Concert < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :artist
    belongs_to :ubication
    has_many_attached :photos
    has_many :interactuables

  ## VALIDATIONS

    validates :tour_name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true

  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

end