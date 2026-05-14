namespace :concerts do

require 'net/http'

  desc "Load concerts from Ticketmaster API"
  task load_from_api: :environment do
    api_key = Rails.application.credentials.ticketmaster[:api_key]
    url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&size=10")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    data["_embedded"]["events"].each do |event|
      
      # Artist creation
      artist_record = nil
      event["_embedded"]["attractions"].each do |artist|
        artist_record = Artist.find_or_create_by(ticketmaster_id: artist["id"]) do |a|
          a.name = artist["name"]
        end
      end
      
      # Concert creation
      if !Concert.find_by(ticketmaster_id: event["id"]).present?
        Concert.create!(tour_name: event["name"], ticketmaster_id: event["id"], artist: artist_record,
          date: event["dates"]["start"]["localDate"], start_time: event["dates"]["start"]["localTime"])
      end
     
      event["_embedded"]["venues"].each do |venue|
        puts venue["city"]["name"]
        puts venue["state"]["name"]
        puts venue["state"]["stateCode"]
        puts venue["country"]["name"]
        puts venue["country"]["countryCode"]
        puts venue["address"] && venue["address"]["line1"] ? venue["address"]["line1"] : "ERROR"
        puts "-----------------------------------"
      end
    end
    
  end

end

