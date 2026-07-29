module TicketmasterEventHelper

    def get_event_name(event)
        event.dig("name")
    end

    def get_event_id(event)
        event.dig("id")
    end

    def get_event_artists(event)
        event.dig("_embedded", "attractions")
    end

    def get_event_date(event)
        #return Date.parse(event.dig("dates", "start", "dateTime")) if event.dig("dates", "start", "dateTime")
        Date.parse(event.dig("dates", "start", "localDate"))
    end

    #get the local time to show directly
    def get_event_time(event)
        time = event.dig("dates", "start", "localTime")
        time ? Time.parse(time) : nil
    end

    def get_event_datetime(event)
        local_date = event.dig("dates", "start", "localDate")
        local_time = event.dig("dates", "start", "localTime")
        Time.zone.parse("#{local_date} #{local_time}")
    end

    def get_event_venue(event)
        event.dig("_embedded", "venues", 0)
    end
    
    def get_event_image_url(event)
        best_quality_image(event.dig("images")).dig("url")
    end

    def get_venue_city(venue)
        venue.dig("city", "name")
    end

    def get_venue_state(venue)
        venue.dig("state", "name")
    end

    def get_venue_country(venue)
        venue.dig("country", "name")
    end

    def get_venue_country_code(venue)
        venue.dig("country", "countryCode")
    end

    def get_venue_address(venue)
        venue.dig("name") || venue.dig("address", "line1")
    end

    def get_full_ubication(event) 
        venue = get_event_venue(event)
        return if venue.nil?
        parts = [get_venue_address(venue), get_venue_city(venue)]
        parts << get_venue_state(venue) unless get_venue_country(venue) == "Spain"
        parts << get_venue_country(venue)
        parts.reject(&:blank?).join(", ")
    end

end
