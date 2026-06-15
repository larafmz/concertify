require 'net/http'
require "open-uri"
class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]

    @artists = TicketmasterService.artists_by_name(query)
    @artists = [] if @artists.nil?

    @concerts_api = TicketmasterService.concerts_by_name(query)
    @concerts_api = [] if @concerts_api.nil?
    @concerts_api = @concerts_api.select do |concert|
        attractions = get_concert_artist_name(concert).present?
    end
  
    # TO/DO los que se hayan borrado de la api pero sigan en la db
    #@concerts_db = Concert.left_joins(:artist).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").order(date: :desc)

    @users = User.where("email ILIKE ?", "%#{query}%")
  end

end
