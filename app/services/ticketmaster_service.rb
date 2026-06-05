class TicketmasterService
    API_KEY = Rails.application.credentials.ticketmaster[:api_key]

    def self.call_api(url) 
        begin
            puts url
            response = Net::HTTP.get(URI(url))
            #response = "prueba error"
            return JSON.parse(response)
        rescue
            puts "Error al conectar con Ticketmaster" #TO/DO mostrar esto en un pop up o algo asi
            return nil
        end
    end

    def self.artists_by_name(name)
        Rails.cache.fetch("ticketmaster_artists_#{name}", expires_in: 10.minutes) do
            data = call_api("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&keyword=#{name}")
            data.dig("_embedded","attractions") if data.present?
        end
    end
  
    def self.artist_by_id(id)
        data = call_api("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&id=#{id}")
        data.dig("_embedded","attractions", 0) if data.present?
    end

    
    def self.concert_by_id(id)
        data = call_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&id=#{id}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
        data.dig("_embedded","events").first if data.present?
    end


    def self.concerts_by_name(name)
        Rails.cache.fetch("ticketmaster_concerts_#{name}", expires_in: 10.minutes) do
            data = call_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&keyword=#{name}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
            data.dig("_embedded","events") if data.present?
        end
    end

    def self.concerts_by_artist_id(id)
        Rails.cache.fetch("ticketmaster_concerts_artist_#{id}", expires_in: 10.minutes) do
            data = call_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&attractionId=#{id}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
            data.dig("_embedded","events") if data.present?
        end
    end

    def self.genres
        data = call_api("https://app.ticketmaster.com/discovery/v2/classifications.json?apikey=#{API_KEY}")
        genres = data.dig("_embedded","classifications").find { |c| c.dig("segment", "name") == "Music" }.dig("segment", "_embedded", "genres")
        genres
    end



end