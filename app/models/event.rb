class Event < ApplicationRecord

  ##CONFIGURATIONS

    extend TicketmasterEventHelper
    include ApplicationHelper

  ## RELATIONSHIPS
    has_many :artists_events, dependent: :destroy
    has_many :artists, through: :artists_events
    has_many :registers, dependent: :destroy
    has_many :future_assistances, dependent: :destroy
    has_many :publications, dependent: :destroy
    has_one :chat, dependent: :destroy 

    belongs_to :ubication, optional: true
    accepts_nested_attributes_for :ubication, allow_destroy: false
    belongs_to :request, optional: true, dependent: :destroy

    has_one_attached :photo

  ## SCOPES

    scope :by_name, -> (query) { left_joins(:artists).where("events.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").distinct }
    scope :by_country_code, -> (country_code) { left_joins(ubication: :country).where(countries: { code: country_code }) }
    scope :by_genre, -> (genre_id) { left_joins(:artists).where(artists: { genre_id: genre_id }) }
    scope :by_artist, -> (artist_id) { left_joins(:artists).where(artists: { id: artist_id} )}
    scope :by_date, -> (date) { where(date: date) }
    scope :before_date, -> (date) { where(date: ...date) }

    scope :requests, -> { where.not(request: nil) }
    scope :accepted, -> { left_joins(:request).merge(Request.accepted).or(where(requests: { id: nil }).where.not(ticketmaster_id: nil)) }
    scope :pending, -> { joins(:request).merge(Request.pending) }

  ## VALIDATIONS

    validates :tour_name, :date, presence: true
    validates :ticketmaster_id, uniqueness: { allow_nil: true }

  ## CLASS METHODS

  public

    def self.create_or_update_by_ticketmaster_id(ticketmaster_id)
      event = Event.find_or_initialize_by(ticketmaster_id: ticketmaster_id)
      if event.new_record? || event.updated_at < 5.hours.ago
        event_api = TicketmasterService.event_by_id(ticketmaster_id)
        return event if event_api.nil?
        
        if event_api.dig("images").present?
          image = get_event_image_url(event_api)
          event.photo.attach(io: URI.open(image), filename: image, content_type: "image/jpg")
        end

        artists = get_event_artists(event_api)
          artists&.each do |artist|
            a = Artist.create_or_update_by_ticketmaster_id(artist["id"])
            event.artists << a if a && !event.artists.include?(a)
        end 

        event.tour_name = event_api.dig("name")
        event.date = get_event_date(event_api)
        event.start_time = get_event_datetime(event_api)
        venue = get_event_venue(event_api)
        event.ubication = venue.nil? ? nil : Ubication.find_or_create_by(city: get_venue_city(venue), state: get_venue_state(venue), country: Country.find_by(code: get_venue_country_code(venue)), venue: get_venue_address(venue))
        event.save!
        event.touch # updates "updated_at" field
      end
      return event
    end

    def self.search_by(params, events_api, artist: nil)
      #return Event.none unless params[:search].present?

      events_db = Event.accepted.by_name(params[:search])
      events_db = events_db.by_artist(artist.id) if artist

      ticketmaster_ids = events_api.map { |event| event["id"] }
      events_db = events_db.where(ticketmaster_id: nil).or(events_db.where.not(ticketmaster_id: ticketmaster_ids)).order(date: :asc)
      
      events_db = events_db.by_country_code(params[:country]) if params[:country].present?

      first_date = params[:first_date]
      second_date = params[:second_date]

      if first_date || second_date
        first_date =  Date.parse(first_date) if first_date.present? && !first_date.is_a?(Date)
        second_date = Date.parse(second_date) if second_date.present? && !second_date.is_a?(Date)
        #first_date ||= Date.today-365.days
        events_db = events_db.where("date >= ?", first_date) if first_date.present?
        events_db = events_db.where("date <= ?", second_date) if second_date.present?
      end

      events_db
    end

  ## INSTANCE METHODS

    def complete_name
      tour_name
    end

    def complete_info
      [tour_name, date_in_numbers(date), start_time, ubication.complete_name_with_venue].reject(&:blank?).join(", ")
    end

    def average_rating
      registers.average(:rating).to_i || 0
    end

    def days_left(actual: Date.today)
      (actual - self.date).to_i.abs
    end

    def get_photo
      self.photo if self.photo.attached?
      self.artists&.first&.photo 
    end

    def accepted?
      !manually_added || (request && request.accepted?)
    end

    def manually_added
      ticketmaster_id.nil?
    end

end