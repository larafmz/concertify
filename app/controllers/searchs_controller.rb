require 'net/http'
require "open-uri"
include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search] 
    genre_name = params[:genre] ? Genre.find(params[:genre]).name: nil

    @artists_api = Array(TicketmasterService.artists_by(query, genre_name))
    @artists_db =  @artists_api.nil? ? Artist.search_by(query, params[:genre]) : []

    @concerts_api = TicketmasterService.concerts_by(query, nil, params[:first_date], params[:second_date], params[:country])
    @concerts_db = Concert.search_by(query, params[:first_date], params[:second_date], params[:country], @concerts_api)
   
    @users = User.by_name(query)
  end

end
