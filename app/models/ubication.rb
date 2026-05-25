class Ubication < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :country
    has_many :concerts

  ## VALIDATIONS

  # there are concerts in ticketmaster without state or city
    
  ## INSTANCE METHODS

    def complete_name_with_address
      "#{address}, #{city}, #{state}, #{country.name}"
    end  

    def complete_name 
      "#{city}, #{state}, #{country.name}"
    end

end