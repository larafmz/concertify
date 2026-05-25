namespace :concerts do

require 'net/http'
require "open-uri"

  desc "Load concerts from Ticketmaster API"
  task load_from_api: :environment do
    api_key = Rails.application.credentials.ticketmaster[:api_key]

    (26..30).each do |n| 

      puts n
      #url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&size=10")

      #url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&classificationName=music&startDateTime=2027-01-01T00:00:00Z&sort=date,asc&page=#{n}&size=1")
      url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&classificationName=music&startDateTime=2026-05-25T00:00:00Z&sort=date,asc&page=#{n}&size=25")
      puts url
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      
      data["_embedded"]["events"].each do |event|

        # skip if concert already exists
        next if Concert.find_by(ticketmaster_id: event.dig("id")).present?
        # skip if there are no venues
        next if event.dig("_embedded", "venues").blank?
        # skip if there are no artists
        next if event.dig("_embedded","attractions").blank? 
        next if event.dig("_embedded","attractions").first.dig("name").blank?

        # Artist creation
        artist = event.dig("_embedded","attractions").first
        artist_record = Artist.find_or_create_by!(ticketmaster_id: artist.dig("id")) do |a|
          a.name = artist.dig("name")
          if artist.dig("images").present?
            artist.dig("images").each do |image|
                a.photos.attach(io: URI.open(image.dig("url")), filename: image.dig("url"), content_type: "image/jpg")
            end
          end
          puts "Created artist: #{a.name}"
        end
        
        # Concert creation
        venue = event.dig("_embedded", "venues").first
        address= venue.dig("address", "line1")
        country = Country.find_by(code: venue.dig("country", "countryCode"))
        state = venue.dig("state", "name")
        city = venue.dig("city", "name")
        ubication = Ubication.find_or_create_by!(city: city, state: state, address: address, country: country)
        Concert.create!(tour_name: event.dig("name"), ticketmaster_id: event.dig("id"), artist: artist_record,
          date: event.dig("dates", "start", "localDate"), start_time: event.dig("dates", "start", "localTime"), ubication: ubication)
        puts "Created concert: #{event.dig("name")}"
       
        
      end

    end
    
  end

end

