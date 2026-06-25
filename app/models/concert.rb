include TicketmasterConcertHelper

class Concert < ApplicationRecord

  ##CONFIGURATIONS

  kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## RELATIONSHIPS
    has_many :artists_concerts, dependent: :destroy
    has_many :artists, through: :artists_concerts
    belongs_to :ubication
    has_one_attached :photo
    has_many :registered_concerts, dependent: :destroy
    has_many :future_assistances, dependent: :destroy
    belongs_to :requester, class_name: "User", optional: true

  ## SCOPES

    scope :by_name, -> (query) { left_joins(:artists).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").distinct }
    scope :by_country_code, ->(country_code) { left_joins(ubication: :country).where(countries: { code: country_code }) }
    scope :accepted, -> { where(status: 0).or(where(status: nil)) }
    scope :pending, -> { where(status: 1) }

  ## VALIDATIONS

    validates :tour_name, :date, presence: true
    validates :ticketmaster_id, uniqueness: { allow_nil: true }

  ## CLASS METHODS

    def self.get_by_ticketmaster_id(id)
      concert = Concert.find_or_create_by!(ticketmaster_id: id) do |c|
        concert_api = TicketmasterService.concert_by_id(id)
        artists = get_concert_artists(concert_api)
        artists&.each do |artist|
          a = Artist.get_by_ticketmaster_id(artist["id"])
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
      concerts_db = Concert.accepted.by_name(query)

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
    
    def status_string
      status ? get_status_name : "Aceptado"
    end

    def pending?
      status == 1
    end

    def accepted?
      status == 0 || status == nil
    end

    def color_request
      case status
      when 1
        "rgb(252, 170, 46)"
      when 2
        "rgb(245, 83, 83)"
      else
        "rgb(88, 216, 94);"
      end
    end

    def second_color_request
      case status
        when 1
          "rgb(78, 61, 41)"
        when 2
          "rgb(78, 41, 41);"
        else
          "rgb(48, 66, 49)"
        end
    end

    def message_request
      case status
      when 1
        "Estamos verificando los detalles del evento."
      when 2
        "No hemos podido verificar este evento. Comprueba las fechas y el recinto e inténtalo de nuevo."
      else
        "Concierto verificado y añadido a la aplicación."
      end
    end

     def emoji_request
      case status
      when 1
        "⌛︎"
      when 2
        "X"
      else
        "✓"
      end
    end


end