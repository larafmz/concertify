include TicketmasterConcertHelper

class Concert < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :artist
    belongs_to :ubication
    has_many_attached :photos
    has_many :interactuables, dependent: :destroy

  ## VALIDATIONS

    validates :tour_name, :ticketmaster_id, :date, presence: true
    validates :ticketmaster_id, uniqueness: true

  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

    def self.get_or_create_by_id(id)
      concert = Concert.find_or_create_by!(ticketmaster_id: id) do |c|
        concert_api = TicketmasterService.concert_by_id(id)
        artist = Artist.get_or_create_by_id(get_concert_artist_id(concert_api))
        c.artist = artist
        c.date = get_concert_date(concert_api)
        c.tour_name = concert_api.dig("name")
        c.start_time = get_concert_time(concert_api)
        venue = get_concert_venue(concert_api)
        c.ubication = Ubication.find_or_create_by(city: get_venue_city(venue), state: get_venue_state(venue), country: Country.find_by(code: get_venue_country_code(venue)), address: get_venue_address(venue))
      end
      return concert
    end

end