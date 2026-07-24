class ArtistsController < ApplicationController
  include ApplicationHelper

  before_action :set_artist, except: [:index, :requested, :show]

  def index
    @artists = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC")
  end

  def show

    @artist = Artist.get_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @artist = Artist.find_by(id: params[:artist_id] || params[:id]) if !@artist

    if @artist.present?
      ticketmaster_id = params[:ticketmaster_id] || @artist.ticketmaster_id
      concerts_api = TicketmasterService.concerts_by(nil, ticketmaster_id, params[:first_date], params[:second_date], params[:country]) ||[]
      ticketmaster_ids = concerts_api.map { |concert| concert["id"] }
      concerts_db = @artist.search_concerts_by(params[:first_date], params[:second_date], params[:country], concerts_api)
      @concerts = TicketmasterService.merge_concerts(concerts_db, concerts_api)
    else
      redirect_back fallback_location: root_path
      #TO/DO error o mensaje idk
    end
  end

  def followers
    @followers = @artist.relations.map(&:follower)
  end

  def publications
    @publications = @artist.publications.order("created_at DESC")
  end

  def registers
    @registers = @artist.registers.order("created_at DESC")
  end

  def follow
    @artist.follow(current_user.id)
    redirect_back fallback_location: root_path
  end

  def unfollow
    @artist.unfollow(current_user.id)
    redirect_back fallback_location: root_path
  end

  def mark_as_favorite
    if current_user.can_mark_favorite?
      @artist.mark_as_favorite(current_user.id)
    end
    redirect_back fallback_location: root_path
  end

  def unmark_as_favorite
    @artist.unmark_as_favorite(current_user.id)
    redirect_back fallback_location: root_path
  end

  def requested
    #TO/DO only to admin role, or maybe delete idk
    @artists = Artist.where.not(requester_id: nil).order("created_at DESC")
  end

  def destroy
    if @artist.requester_id == current_user.id && @artist.pending? #TO/DO or admin
      @artist.destroy
    end
    redirect_back fallback_location: root_path
  end

private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def create_params
      params.require(:artist).permit(:name, :requester_id, :status)
  end 

end