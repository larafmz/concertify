class Concert < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :artist
    has_many_attached :photos

  ## VALIDATIONS

    validates :tour_name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true

  ## INSTANCE METHODS

    def complete_name #Complete name
      tour_name
    end

end