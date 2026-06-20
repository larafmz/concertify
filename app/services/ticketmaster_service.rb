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
        data = call_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&id=#{id}&sort=date,asc&size=200")
        data.dig("_embedded","events").first if data.present?
    end


    def self.concerts_by(name, artist_id, first_date, second_date, country_code)
        first_date  = Date.parse(first_date)  if first_date.present?
        second_date = Date.parse(second_date) if second_date.present?
        second_date = first_date if !second_date.present?
        first_date ||= Date.today
        first_date  = "#{first_date.to_date}T00:00:00" if first_date.present?
        second_date = "#{second_date.to_date}T23:59:59" if second_date.present?

        return [] if (name.nil? || name.empty?) && (artist_id.nil? || artist_id.empty?)
        Rails.cache.fetch("ticketmaster_concerts_#{name}_#{artist_id}_#{first_date}_#{second_date}", expires_in: 10.minutes) do
            url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&keyword=#{name}&sort=date,asc&size=150&localStartDateTime=#{first_date},#{second_date}"
            url += "&attractionId=#{artist_id}" if artist_id.present?
            url += "&countryCode=#{country_code}" if country_code.present?
            data = call_api(url)
            data = data.dig("_embedded","events") if data.present?
            return [] if data.nil?
            # data = data.select do |concert|
            #     get_concert_artist_name(concert).present?
            # end
            data
        end
    end

    def self.genres
        data = call_api("https://app.ticketmaster.com/discovery/v2/classifications.json?apikey=#{API_KEY}")
        genres = data.dig("_embedded","classifications").find { |c| c.dig("segment", "name") == "Music" }.dig("segment", "_embedded", "genres")
        genres
    end



end