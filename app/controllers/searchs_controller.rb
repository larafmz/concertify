require 'net/http'
require "open-uri"
include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]
    first_date = Time.zone.parse(params[:first_date]).beginning_of_day.utc.iso8601 if params[:first_date] && !params[:first_date].empty?
    second_date = Time.zone.parse(params[:second_date]).beginning_of_day.utc.iso8601 if params[:second_date] && !params[:second_date].empty?
    country = params[:country]

    @artists = TicketmasterService.artists_by_name(query)
    @artists = [] if @artists.nil?

    @concerts_api = TicketmasterService.concerts_by(query, first_date, second_date)
    @concerts_api = [] if @concerts_api.nil?
    @concerts_api = @concerts_api.select do |concert|
      attractions = get_concert_artist_name(concert).present?
    end
  
    # TO/DO los que se hayan borrado de la api pero sigan en la db
    #@concerts_db = Concert.left_joins(:artist).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").order(date: :desc)

    @users = User.where("email ILIKE ?", "%#{query}%")
  end

end
