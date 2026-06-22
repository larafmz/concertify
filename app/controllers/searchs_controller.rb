require 'net/http'
require "open-uri"
include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search]

    @artists_api = Array(TicketmasterService.artists_by_name(query))
    @artists_db =  @artists.nil? ? Artist.by_name(query) : []

    @concerts_api = TicketmasterService.concerts_by(query, nil, params[:first_date], params[:second_date], params[:country])
    @concerts_db = Concert.search_by(query, params[:first_date], params[:second_date], params[:country], @concerts_api)
   
    @users = User.where("email ILIKE ?", "%#{query}%")
  end

end
