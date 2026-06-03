module TicketmasterConcertHelper

    def get_concert_name(concert)
        concert.dig("name")
    end

    def get_concert_artist_id(concert)
        concert.dig("_embedded", "attractions", 0, "id")
    end

    def get_concert_artist_name(concert)
        concert.dig("_embedded", "attractions", 0, "name")
    end

    def get_concert_date(concert)
        Date.parse(concert.dig("dates", "start", "localDate"))
    end

    def get_concert_time(concert)
        time = concert.dig("dates", "start", "localTime")
        time ? Time.parse(time) : nil
    end

    def get_concert_venue(concert)
        concert.dig("_embedded", "venues", 0)
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
        venue.dig("address", "line1")
    end

end
