require 'net/http'
require "open-uri"
include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]
    country = params[:country]

    @artists = TicketmasterService.artists_by_name(query)
    @artists = [] if @artists.nil?

    @concerts_api = TicketmasterService.concerts_by(query, nil, params[:first_date], params[:second_date])
    @concerts_db = Concert.search_by(query, nil, params[:first_date], params[:second_date], @concerts_api)
   
    @users = User.where("email ILIKE ?", "%#{query}%")
  end

end
