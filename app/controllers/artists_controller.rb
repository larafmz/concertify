class ArtistsController < ApplicationController
  include ApplicationHelper

  def index
    @user = User.find(params[:user_id]) if params[:user_id].present?
    @artists = @user.followings.artists if @user.present?
  end

  def new
    @artist = Artist.new
    render layout: false
  end

  def create
      @artist = Artist.new(create_params)
      if @artist.save!
          redirect_to requested_artists_path
      else
          redirect_back fallback_location: root_path
      end
  end

  def edit
    @artist = Artist.find(params[:id])
    render layout: false
  end

  def update
      @artist = Artist.find(params[:id])
      
      if @artist.update(create_params)
          redirect_to requested_artists_path
      else
          redirect_back fallback_location: root_path
      end
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
      
      @registered_concerts = @artist.registered_concerts
      @reviews = @registered_concerts.with_review
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

  def mark_as_favorite
    if current_user.can_mark_favorite?
      Artist.find(params[:id]).mark_as_favorite(current_user.id)
    end
    redirect_back fallback_location: root_path
  end

  def unmark_as_favorite
    Artist.find(params[:id]).unmark_as_favorite(current_user.id)
    redirect_back fallback_location: root_path
  end

  def requested
    #TO/DO only to admin role, or maybe delete idk
    @artists = Artist.where.not(requester_id: nil).order("created_at DESC")
  end

  def destroy
    @artist = Artist.find(params[:id])
    if @artist.requester_id == current_user.id && @artist.pending? #TO/DO or admin
      @artist.destroy
    end
    redirect_back fallback_location: root_path
  end

private

  def create_params
      params.require(:artist).permit(:name, :requester_id, :status)
  end 

end