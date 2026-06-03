class TicketmasterService
    API_KEY = Rails.application.credentials.ticketmaster[:api_key]

    def self.artists_by_name(name)
        Rails.cache.fetch("ticketmaster_artists_#{name}", expires_in: 10.minutes) do
            url= URI("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&keyword=#{name}")
            puts url
            response = Net::HTTP.get(url)
            data = JSON.parse(response)
            data.dig("_embedded","attractions")
        end
    end
  
    def self.artist_by_id(id)
        url= URI("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&id=#{id}")
        puts url
        response = Net::HTTP.get(url)
        data = JSON.parse(response)
        data.dig("_embedded","attractions").first
    end

    
    def self.concert_by_id(id)
        url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&id=#{id}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
        response = Net::HTTP.get(url)
        puts url
        data = JSON.parse(response)
        data.dig("_embedded","events").first
    end


    def self.concerts_by_name(name)
        Rails.cache.fetch("ticketmaster_concerts_#{name}", expires_in: 10.minutes) do
            url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&keyword=#{name}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
            response = Net::HTTP.get(url)
            puts url
            data = JSON.parse(response)
            data.dig("_embedded","events")
        end
    end

    def self.concerts_by_artist_id(id)
        Rails.cache.fetch("ticketmaster_concerts_artist_#{id}", expires_in: 10.minutes) do
            url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&attractionId=#{id}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
            response = Net::HTTP.get(url)
            puts url
            data = JSON.parse(response)
            data.dig("_embedded","events")
        end
    end

    def self.genres
        url= URI("https://app.ticketmaster.com/discovery/v2/classifications.json?apikey=#{API_KEY}")
        response = Net::HTTP.get(url)
        data = JSON.parse(response)
        genres = data.dig("_embedded","classifications").find { |c| c.dig("segment", "name") == "Music" }.dig("segment", "_embedded", "genres")
        genres
    end



end