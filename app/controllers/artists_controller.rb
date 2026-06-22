class ArtistsController < ApplicationController
  include ApplicationHelper

  def show

    if params[:ticketmaster_id]
      @artist = Artist.get_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    elsif params[:artist_id]
      @artist = Artist.find(params[:artist_id])
    else
      @artist = Artist.find(params[:id])
    end


    if @artist.present?
      ticketmaster_id = params[:ticketmaster_id] || @artist.ticketmaster_id
      @concerts_api = TicketmasterService.concerts_by(nil, ticketmaster_id, params[:first_date], params[:second_date], params[:country]) ||[]
      ticketmaster_ids = @concerts_api.map { |concert| concert["id"] }
      @concerts_db = @artist.search_concerts_by(params[:first_date], params[:second_date], params[:country], @concerts_api)
      @registered_concerts = @artist.registered_concerts
    else
      #TO/DO error o mensaje idk
    end
  end

end