require "net/http"
require "uri"
require "json"

class TicketmasterService
    API_KEY = Rails.application.credentials.ticketmaster[:api_key]

    def self.call_api(url) 
        begin
            puts url
            response = Net::HTTP.get(URI(url))
            return JSON.parse(response)
        rescue
            puts "Error al conectar con Ticketmaster" #TO/DO mostrar esto en un pop up o algo asi
            return nil
        end
    end

    def self.artists_by(name, genre: nil)
        Rails.cache.fetch("ticketmaster_artists_#{name}", expires_in: 10.minutes) do
            genre = "music" if genre.nil? || genre.empty? 
            data = call_api("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=#{genre}&keyword=#{name}")
            data.dig("_embedded","attractions") if data.present?
        end
    end

    
    def self.artist_by_name(name)
        attractions = artists_by(name)
        exact_match = attractions.find do |artist|
            artist["name"].casecmp?(name)
        end
        exact_match || nil
    end
  
    def self.artist_by_id(id)
        data = call_api("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&id=#{id}")
        data.dig("_embedded","attractions", 0) if data.present?
    end

    
    def self.event_by_id(id)
        data = call_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&id=#{id}&sort=date,asc&size=200")
        data&.dig("_embedded","events")&.first 
    end

    def self.events_by(query:nil, artist_id:nil, first_date:nil, second_date:nil, country_code:nil, size:10)
        first_date  = first_date.presence #converts empty to nil
        second_date = second_date.presence #converts empty to nil
        first_date  = Date.parse(first_date) if first_date && !first_date.is_a?(Date)
        second_date = Date.parse(second_date) if second_date && !second_date.is_a?(Date)
        first_date ||= Date.today-5.year # no guarda tan atras ticketmaster pero por si acaso
        first_date  = "#{first_date.to_date}T00:00:00" if first_date.present?
        second_date = "#{second_date.to_date}T23:59:59" if second_date.present?
        
        Rails.cache.fetch("ticketmaster_events_#{query}_#{artist_id}_#{first_date}_#{second_date}", expires_in: 10.minutes) do
            url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&sort=date,asc&size=#{size}&localStartDateTime=#{first_date},#{second_date}"
            url += "&keyword=#{query}" if query.present?
            url += "&attractionId=#{artist_id}" if artist_id.present?
            url += "&countryCode=#{country_code}" if country_code.present?
            data = call_api(url)
            data = data.dig("_embedded","events") if data.present?
            return [] if data.nil?
            data
        end
    end

    def self.genres
        data = call_api("https://app.ticketmaster.com/discovery/v2/classifications.json?apikey=#{API_KEY}")
        genres = data.dig("_embedded","classifications").find { |c| c.dig("segment", "name") == "Music" }.dig("segment", "_embedded", "genres")
        genres
    end

    def self.merge_events(events_db, events_api)
        events = (events_db.map do |event|
            {
                source: :db,
                event: event,
                date: event.date,
                time: event.start_time
            }
            end + events_api.map do |event|
            {
                source: :api,
                event: event,
                date: get_event_date(event),
                time: get_event_time(event)
            }
            end).sort_by { |c| [c[:date], c[:time] || Time.new(2000)] }
    end


end