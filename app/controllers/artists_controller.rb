class ArtistsController < ApplicationController
  include ApplicationHelper

  def show
    
    country = params[:country]

    @artist = Artist.get_or_create_by_id(params[:id])
    @concerts_api = TicketmasterService.concerts_by(nil, params[:id], params[:first_date], params[:second_date]) || []

    ticketmaster_ids = @concerts_api.map { |concert| concert["id"] }
    @concerts_db = Concert.search_by(nil, @artist, params[:first_date], params[:second_date], @concerts_api)
  end

end