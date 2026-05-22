namespace :concerts do

require 'net/http'
require "open-uri"

  desc "Load concerts from Ticketmaster API"
  task load_from_api: :environment do
    api_key = Rails.application.credentials.ticketmaster[:api_key]

    (0..15).each do |n| 

      puts n
      #url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&size=10")

      url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&classificationName=music&startDateTime=2027-01-01T00:00:00Z&sort=date,asc&page=#{n}&size=1")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      
      data["_embedded"]["events"].each do |event|
        
        # Artist creation
        #artist_record = nil
        next if !event["_embedded"]["attractions"].present? # if there are no artists, skip the event
        artist = event["_embedded"]["attractions"].first
        artist_record = Artist.find_or_create_by!(ticketmaster_id: artist["id"]) do |a|
          a.name = artist["name"]
          if artist["images"].present?
            artist["images"].each do |image|
                a.photos.attach(io: URI.open(image["url"]), filename: image["url"], content_type: "image/jpg")
            end
          end
          puts "Created artist: #{a.name}"
        end
        
        # Concert creation
        if !Concert.find_by(ticketmaster_id: event["id"]).present?
          venue = event["_embedded"]["venues"].first
          address= venue["address"] && venue["address"]["line1"] ? venue["address"]["line1"] : nil
          country = Country.find_by(code: venue["country"]["countryCode"])
          state = venue.dig("state", "name")
          ubication = Ubication.find_or_create_by!(city: venue["city"]["name"], state: state, address: address, country: country)
          Concert.create!(tour_name: event["name"], ticketmaster_id: event["id"], artist: artist_record,
            date: event["dates"]["start"]["localDate"], start_time: event["dates"]["start"]["localTime"],
            ubication: ubication)
          puts "Created concert: #{event["name"]}"
        end
        
        
      end

    end
    
  end

end

