class Ubication < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :country
    belongs_to :user, optional: true
    has_many :concerts

  ## VALIDATIONS

  # there are concerts in ticketmaster without state or city
    
  ## INSTANCE METHODS

    def complete_name_with_address
      parts = [address, city]
      parts << state unless country&.name == "Spain"
      parts << country&.name
      parts.reject(&:blank?).join(", ")
    end

    def complete_name 
      str = [city, state, country&.name].reject(&:blank?).join(", ")
    end



end