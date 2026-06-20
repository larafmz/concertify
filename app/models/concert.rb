include TicketmasterConcertHelper

class Concert < ApplicationRecord

  ## RELATIONSHIPS
    has_many :artists_concerts
    has_many :artists, through: :artists_concerts
    belongs_to :ubication
    has_one_attached :photo
    has_many :interactuables, dependent: :destroy
    has_many :registered_concerts
    has_many :future_assistances, dependent: :destroy

  ## SCOPES

    scope :by_name, -> (query) { left_joins(:artists).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").distinct }
    scope :by_country_code, ->(country_code) { left_joins(ubication: :country).where(countries: { code: country_code }) }

  ## VALIDATIONS

    validates :tour_name, :ticketmaster_id, :date, presence: true
    validates :ticketmaster_id, uniqueness: true

  ## CLASS METHODS

    def self.get_or_create_by_id(id)
      concert = Concert.find_or_create_by!(ticketmaster_id: id) do |c|
        concert_api = TicketmasterService.concert_by_id(id)
        artists = get_concert_artists(concert_api)
        artists&.each do |artist|
          a = Artist.get_or_create_by_id(artist["id"])
          c.artists << a if a
        end     
        c.date = get_concert_date(concert_api)
        c.tour_name = concert_api.dig("name")
        c.start_time = get_concert_time(concert_api)

        if concert_api.dig("images").present?
          image = get_concert_image_url(concert_api)
          c.photo.attach(io: URI.open(image), filename: image, content_type: "image/jpg")
        end

        venue = get_concert_venue(concert_api)
        c.ubication = Ubication.find_or_create_by(city: get_venue_city(venue), state: get_venue_state(venue), country: Country.find_by(code: get_venue_country_code(venue)), address: get_venue_address(venue))
      end
      return concert
    end

    def self.search_by(query, first_date, second_date, country_code, concerts_api)
      return [] if !query.present?
      concerts_db = Concert.by_name(query)

      ticketmaster_ids = concerts_api.map { |concert| concert["id"] }
      concerts_db = concerts_db.where.not(ticketmaster_id: ticketmaster_ids).order(date: :asc)

      concerts_db = concerts_db.by_country_code(country_code) if country_code.present?

      if first_date || second_date
        first_date = Date.parse(first_date) if first_date.present?
        second_date = Date.parse(second_date) if second_date.present?
        second_date = first_date if !second_date.present?
        first_date ||= Date.today
        concerts_db = concerts_db.where("date >= ?", first_date) if first_date.present?
        concerts_db = concerts_db.where("date <= ?", second_date) if second_date.present?
      end

      concerts_db
    end


  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

    def average_puntuation
      registered_concerts.average(:puntuation).to_i || 0
    end


end