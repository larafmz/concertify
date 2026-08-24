include TicketmasterEventHelper

class Event < ApplicationRecord

  ##CONFIGURATIONS

  kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## RELATIONSHIPS
    has_many :artists_events, dependent: :destroy
    has_many :artists, through: :artists_events
    has_many :registers, dependent: :destroy
    has_many :future_assistances, dependent: :destroy
    has_many :publications, dependent: :destroy
    has_one :chat, dependent: :destroy 
    
    belongs_to :requester, class_name: "User", optional: true
    belongs_to :ubication, optional: true
    
    has_one_attached :photo

  ## SCOPES

    scope :by_name, -> (query) { left_joins(:artists).where("events.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").distinct }
    scope :by_country_code, ->(country_code) { left_joins(ubication: :country).where(countries: { code: country_code }) }
    scope :by_genre, ->(genre_id) { left_joins(:artists).where(artists: { genre_id: genre_id }) }
    scope :by_artist, -> (artist_id) { left_joins(:artists).where(artists: { id: artist_id} )}
    scope :requests, -> { where.not(requester_id: nil) }
    scope :accepted, -> { where(status: 0).or(where(status: nil)) }
    scope :pending, -> { where(status: 1) }

  ## VALIDATIONS

    validates :tour_name, :date, presence: true
    validates :ticketmaster_id, uniqueness: { allow_nil: true }

  ## CALLBACKS

      after_update :create_notification, if: :saved_change_to_status?
      after_create :create_notification_for_admins

  ## CALLBACK METHODS

  private

      def create_notification
        notification = InteractionNotificationNotifier.with(
            record: self, 
            status: status, 
            status_str: get_status_name, 
            path: Rails.application.routes.url_helpers.requests_user_path(requester.id))
        notification.deliver(requester)
      end

      def create_notification_for_admins
        notification = InteractionNotificationNotifier.with(
            record: self,
            path: Rails.application.routes.url_helpers.requests_events_path)
        notification.deliver(User.admins)
      end

  ## CLASS METHODS

  public

    def self.create_or_update_by_ticketmaster_id(ticketmaster_id)
      event = Event.find_or_initialize_by(ticketmaster_id: ticketmaster_id)
      if event.new_record? || event.updated_at < 5.hours.ago
        event_api = TicketmasterService.event_by_id(ticketmaster_id)
        return event if event_api.nil?
        
        if event.new_record?
          artists = get_event_artists(event_api)
          artists&.each do |artist|
            a = Artist.create_or_update_by_ticketmaster_id(artist["id"])
            event.artists << a if a
          end     
          if event_api.dig("images").present?
            image = get_event_image_url(event_api)
            event.photo.attach(io: URI.open(image), filename: image, content_type: "image/jpg")
          end
        end

        event.tour_name = event_api.dig("name")
        event.date = get_event_date(event_api)
        event.start_time = get_event_datetime(event_api)
        venue = get_event_venue(event_api)
        event.ubication = venue.nil? ? nil : Ubication.find_or_create_by(city: get_venue_city(venue), state: get_venue_state(venue), country: Country.find_by(code: get_venue_country_code(venue)), address: get_venue_address(venue))
        event.save!
      end
      return event
    end

    def self.search_by(query, first_date, second_date, country_code, events_api)
      return Event.none if !query.present?
      events_db = Event.accepted.by_name(query)

      ticketmaster_ids = events_api.map { |event| event["id"] }
      events_db = events_db.where(ticketmaster_id: nil).or(events_db.where.not(ticketmaster_id: ticketmaster_ids)).order(date: :asc)

      events_db = events_db.by_country_code(country_code) if country_code.present?

      if first_date || second_date
        first_date = Date.parse(first_date) if first_date.present?
        second_date = Date.parse(second_date) if second_date.present?
        second_date = first_date if !second_date.present?
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

    def average_rating
      registers.average(:rating).to_i || 0
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

    def days_left(actual: Date.today)
      (actual - self.date).to_i.abs
    end

    ## REQUESTS METHODS 
    
    def color_request(status: self.status)
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
      return I18n.t("request_message.0") if status.nil?
      I18n.t("request_message.#{status}")
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

    ## NOTIFICATION METHODS 

    def notification_message(noti)
      if noti.params[:status]
        str = I18n.t("notifications.event_update")
        status_string = I18n.t("events.statuses.#{noti.params[:status_str].downcase}")
        str+= "<span style='color: #{color_request(status: noti.params[:status])}'>#{status_string.upcase}</span>"
        str.html_safe
      else
        I18n.t("notifications.new_event", tour_name: self.tour_name, artist: self.artists.first.name)
      end
    end

end