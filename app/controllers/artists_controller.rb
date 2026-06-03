class ArtistsController < ApplicationController
  include ApplicationHelper

  def show
    @artist = Artist.get_or_create_by_id(params[:id])
    @concerts_api = TicketmasterService.concerts_by_artist_id(params[:id]) || []
  end

end