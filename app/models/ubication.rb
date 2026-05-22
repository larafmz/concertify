class Ubication < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :country
    has_many :concerts

  ## VALIDATIONS

    validates :city, presence: true # there are concerts in ticketmaster without state
    
  ## INSTANCE METHODS

    def complete_name 
      "#{address}, #{city}, #{state}, #{country.name}"
    end

end