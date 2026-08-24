class Ubication < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :country
    belongs_to :user, optional: true
    has_many :events

  ## VALIDATIONS

  # there are events in ticketmaster without state or city
    
  ## INSTANCE METHODS

    def complete_name_with_venue
      parts = [venue&.titleize, city&.titleize]
      parts << state&.titleize unless country&.name == "Spain"
      parts << I18n.t(country&.name)
      parts.reject(&:blank?).join(", ")
    end

    def complete_name 
      str = [city&.titleize, state&.titleize, I18n.t(country&.name)].reject(&:blank?).join(", ")
    end



end