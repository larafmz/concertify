include TicketmasterEventHelper

class SearchsController < ApplicationController

  API_KEY = Rails.application.credentials.ticketmaster[:api_key]

  def index
    query = params[:search] 
    genre_name = params[:genre] ? Genre.find(params[:genre]).name: nil

    @users = query.present? ? User.viewables(current_user).by_name(query) : []
    
    @artists_api = query.present? || genre_name ? Array(TicketmasterService.artists_by(query, genre_name)) : []
    @artists_db = Artist.search_by(query, genre_name, @artists_api)
    
    events_api = TicketmasterService.events_by(query, nil, params[:first_date], params[:second_date], params[:country])
    events_db = Event.search_by(query, params[:first_date], params[:second_date], params[:country], events_api)
   
    @events = TicketmasterService.merge_events(events_db, events_api)
   
  end

end
