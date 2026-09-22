class ArtistsController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource except: [:show]

  before_action :get_attributes, except: [:index, :requests]

  def index
    artists = Artist.search_by(params: params)
    @artists = Kaminari.paginate_array(artists).page(params[:page]).per(48)
  end

  def show
    @artist = Artist.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @artist = Artist.accepted.find_by(id: params[:artist_id] || params[:id]) unless @artist

    if @artist.present?
      params[:ticketmaster_id] = params[:ticketmaster_id] || @artist.ticketmaster_id || "unfound_artist"
      events = Event.search_by(params: params, artist: @artist)
      @events = Kaminari.paginate_array(events).page(params[:page]).per(10)
      get_attributes
    else
      flash[:alert] = t("not_found_masc", model: Artist.singular.downcase)
      redirect_back fallback_location: root_path
      return
    end
  end

  def edit
  end

  def update
    @artist.update(create_params)
    redirect_back fallback_location: root_path
  end

  def followers
  end

  def publications
    @publications = @publications.page(params[:page]).per(10)
    @pagination_path = request.query_parameters.merge( controller: "artists", action: "publications", artist_id: @artist.id )
    respond_to do |format|
        format.html
        format.turbo_stream
    end
  end

  def registers
  end

  def follow
    @artist.follow(current_user)
    redirect_back fallback_location: root_path
  end

  def unfollow
    @artist.unfollow(current_user)
    redirect_back fallback_location: root_path
  end

  def mark_as_favorite
    @artist.mark_as_favorite(current_user)
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
    @publication = Publication.create(artist_id: params[:id], user_id: current_user&.id, review: params[:text])
    redirect_to interactuable_path(@publication)
  end 

private

  def get_attributes
    if @artist
      @publications = @artist.publications.viewables(current_user).order("created_at DESC")
      @registers = @artist.registers.viewables(current_user).order("created_at DESC")
      @followers = @artist.followers.viewables(current_user)
      @followers_count = @followers.count 
      @average_rating = @artist.average_rating 
      @publications_count = @artist.publications.count 
      @can_mark_favorite = current_user&.can_mark_favorite?
      photo = @artist.photo
      @photo_url = photo.attached? ? url_for(photo) : ActionController::Base.helpers.asset_path("default-event.jpg")
    end
  end

  def create_params
      params.require(:artist).permit(:name, :requester_id, :status, :photo)
  end 

end