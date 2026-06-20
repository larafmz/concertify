class ArtistsController < ApplicationController
  include ApplicationHelper

  def show
    
    country = params[:country]

    @artist = Artist.get_or_create_by_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @artist = Artist.find(params[:id]) if @artist.nil?

    if @artist.present?
      @concerts_api = TicketmasterService.concerts_by(nil, params[:id], params[:first_date], params[:second_date], params[:country]) || []
      ticketmaster_ids = @concerts_api.map { |concert| concert["id"] }
      @concerts_db = @artist.search_concerts_by(params[:first_date], params[:second_date], params[:country], @concerts_api)
    else
      #TO/DO error o mensaje idk
    end
  end

end