class ArtistsController < ApplicationController
  include ApplicationHelper

  def show

    @artist = Artist.get_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @artist = Artist.find_by(id: params[:artist_id] || params[:id]) if !@artist

    if @artist.present?
      ticketmaster_id = params[:ticketmaster_id] || @artist.ticketmaster_id
      @concerts_api = TicketmasterService.concerts_by(nil, ticketmaster_id, params[:first_date], params[:second_date], params[:country]) ||[]
      ticketmaster_ids = @concerts_api.map { |concert| concert["id"] }
      @concerts_db = @artist.search_concerts_by(params[:first_date], params[:second_date], params[:country], @concerts_api)
      @registered_concerts = @artist.registered_concerts
    else
      redirect_back fallback_location: root_path
      #TO/DO error o mensaje idk
    end
  end

  def follow
    Artist.find(params[:id]).follow(current_user.id)
    redirect_back fallback_location: root_path
  end

  def unfollow
    Artist.find(params[:id]).unfollow(current_user.id)
    redirect_back fallback_location: root_path
  end

end