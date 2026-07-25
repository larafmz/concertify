include TicketmasterConcertHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search] 
    genre_name = params[:genre] ? Genre.find(params[:genre]).name: nil

    @users = query.present? ? User.viewables(current_user).by_name(query) : []
    
    @artists_api = query.present? || genre_name ? Array(TicketmasterService.artists_by(query, genre_name)) : []
    @artists_db =  @artists_api.nil? && (query.present? || genre_name) ? Artist.search_by(query, params[:genre]) : []
    
    concerts_api = TicketmasterService.concerts_by(query, nil, params[:first_date], params[:second_date], params[:country])
    concerts_db = Concert.search_by(query, params[:first_date], params[:second_date], params[:country], concerts_api)
    @concerts = TicketmasterService.merge_concerts(concerts_db, concerts_api)
   
  end

end
