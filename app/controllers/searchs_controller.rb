require 'net/http'
require "open-uri"
include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]

    @artists = TicketmasterService.artists_by_name(query) || []
    @artists_db = Artist.by_name(query) || [] if @artists.nil?

    @concerts_api = TicketmasterService.concerts_by(query, nil, params[:first_date], params[:second_date], params[:country])
    @concerts_db = Concert.search_by(query, params[:first_date], params[:second_date], params[:country], @concerts_api)
   
    @users = User.where("email ILIKE ?", "%#{query}%")
  end

end
