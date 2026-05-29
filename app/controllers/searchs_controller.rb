require 'net/http'
require "open-uri"
class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]

    @artists = get_ticketmaster_artists(query)
    @artists = [] if @artists.nil?

    @concerts_api = get_ticketmaster_concerts(query)
    @concerts_api = [] if @concerts_api.nil?
    @concerts_api = @concerts_api.select do |concert|
        attractions = concert.dig("_embedded", "attractions")
        attractions.present? && attractions.first&.dig("name").present?
    end
  
    #@concerts_db = Concert.left_joins(:artist).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").order(date: :desc)

    @users = User.where("email ILIKE ?", "%#{query}%")
  end


  def get_ticketmaster_artists(query)
    Rails.cache.fetch("ticketmaster_artists_#{query}", expires_in: 10.minutes) do
      url= URI("https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=#{API_KEY}&classificationName=music&keyword=#{query}")
      puts url
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      data.dig("_embedded","attractions")
    end
  end

  def get_ticketmaster_concerts(query)
    Rails.cache.fetch("ticketmaster_concerts_#{query}", expires_in: 10.minutes) do
      url= URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&classificationName=music&keyword=#{query}&startDateTime=2010-01-01T00:00:00Z&sort=date,asc&size=200")
      response = Net::HTTP.get(url)
      puts url
      data = JSON.parse(response)
      data.dig("_embedded","events")
    end
  end

end
