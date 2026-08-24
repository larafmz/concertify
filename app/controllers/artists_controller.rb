class ArtistsController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource

  before_action :set_artist, except: [:index, :requests, :show]

  def index
    @artists = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC")
  end

  def show

    @artist = Artist.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @artist = Artist.find_by(id: params[:artist_id] || params[:id]) if !@artist

    if @artist.present?
      ticketmaster_id = params[:ticketmaster_id] || @artist.ticketmaster_id
      events_api = TicketmasterService.events_by(query: nil, artist_id: ticketmaster_id, first_date: params[:first_date], second_date: params[:second_date], country_code: params[:country], size: 100) ||[]
      ticketmaster_ids = events_api.map { |event| event["id"] }
      events_db = @artist.search_events_by(params[:first_date], params[:second_date], params[:country], events_api)
      @events = TicketmasterService.merge_events(events_db, events_api)
    else
      redirect_back fallback_location: root_path
      #TO/DO error o mensaje idk
    end
  end

  def followers
  end

  def publications
  end

  def registers
  end

  def follow
    @artist.follow(current_user&.id)
    redirect_back fallback_location: root_path
  end

  def unfollow
    @artist.unfollow(current_user&.id)
    redirect_back fallback_location: root_path
  end

  def mark_as_favorite
    if current_user.can_mark_favorite?
      @artist.mark_as_favorite(current_user&.id)
    end
    redirect_back fallback_location: root_path
  end

  def unmark_as_favorite
    @artist.unmark_as_favorite(current_user&.id)
    redirect_back fallback_location: root_path
  end

  def destroy
    @artist.destroy
    redirect_back fallback_location: root_path
  end

  def post
    Publication.create(artist_id: params[:id], user_id: current_user&.id, review: params[:text])
    redirect_to publications_artist_path(@artist)
  end 

private

  def set_artist
    @artist = Artist.find(params[:id])
    @publications = @artist.publications.viewables(current_user).order("created_at DESC")
    @registers = @artist.registers.viewables(current_user).order("created_at DESC")
    @followers = @artist.followers.viewables(current_user)
  end

  def create_params
      params.require(:artist).permit(:name, :requester_id, :status)
  end 

end