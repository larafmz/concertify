module TicketmasterConcertHelper

    def get_concert_name(concert)
        concert.dig("name")
    end

    def get_concert_id(concert)
        concert.dig("id")
    end

    def get_concert_artists(concert)
        concert.dig("_embedded", "attractions")
    end

    def get_concert_date(concert)
        #return Date.parse(concert.dig("dates", "start", "dateTime")) if concert.dig("dates", "start", "dateTime")
        Date.parse(concert.dig("dates", "start", "localDate"))
    end

    def get_concert_time(concert)
        time = concert.dig("dates", "start", "localTime")
        time ? Time.parse(time) : nil
    end

    def get_concert_venue(concert)
        concert.dig("_embedded", "venues", 0)
    end
    
    def get_concert_image_url(concert)
        best_quality_image(concert.dig("images")).dig("url")
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

    def get_full_ubication(concert) 
        venue = get_concert_venue(concert)
        parts = [get_venue_address(venue), get_venue_city(venue)]
        parts << get_venue_state(venue) unless get_venue_country(venue) == "Spain"
        parts << get_venue_country(venue)
        parts.reject(&:blank?).join(", ")
    end

end
