class ConcertsController < ApplicationController
  include ApplicationHelper

  def show
    @concert = Concert.get_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @concert = Concert.accepted.find_by(id: params[:id]) if @concert.nil?
    if @concert
      @concert_date_status = time_status(@concert.date, @concert.start_time)
      @registered_concerts = RegisteredConcert.where(concert_id: @concert.id).order("created_at ASC") # TO/DO order by likes
      @reviews = @registered_concerts.with_review
      @future_assistances = FutureAssistance.where(concert_id: @concert.id).order("created_at ASC") 
    else
      redirect_back fallback_location: root_path
    end
  end

  
  def new
    @concert = Concert.new
    render layout: false
  end

  def create
      @concert = Concert.new(create_params)
      
      # Search artist in DB
      @artist = Artist.find_by(name: params[:concert][:artist_name])
      # Search artist in Ticketmaster
      if !@artist
        artist_api = TicketmasterService.artists_by(params[:concert][:artist_name], nil)&.first
        @artist = Artist.get_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
      end
      #Create artist with status pending
      @artist = Artist.create(name: params[:concert][:artist_name], requester_id: current_user.id, status: 1) if !@artist
      
      @concert.artists << @artist
      @concert.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id, city: params[:city])

      if @concert.save!
          redirect_to requested_concerts_path
      else
          redirect_back fallback_location: root_path
      end
  end

    
  def edit
    @concert = Concert.find(params[:id])
    render layout: false
  end

  def update
      @concert = Concert.find(params[:id])
      @artist = Artist.find_by(name: params[:concert][:artist_name])
      if !@artist
        artist_api = TicketmasterService.artists_by(params[:concert][:artist_name], nil)&.first
        @artist = Artist.get_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
      end
      @concert.artists = [@artist] if @artist
      @concert.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id, city: params[:city])

      if @concert.update(create_params)
          redirect_to requested_concerts_path
      else
          redirect_back fallback_location: root_path
      end
  end

  def requested
    #TO/DO if role admin, show all requesteds
    @concerts = Concert.where(requester_id: params[:user_id]).order("created_at DESC")
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end

      
  def destroy
      @concert = Concert.find(params[:id])
      if @concert.requester_id == current_user.id && @concert.pending? #TO/DO or admin
        @concert.destroy
      end
      redirect_back fallback_location: root_path
  end


  private

  def create_params
      params.require(:concert).permit(:date, :tour_name, :artist_id, :requester_id, :status, :ubication_id)
  end 

end