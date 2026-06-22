class ConcertsController < ApplicationController
  include ApplicationHelper

  def show
    @concert = Concert.get_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @concert = Concert.accepted.find_by(id: params[:id]) if @concert.nil?
    if @concert
      @concert_date_status = time_status(@concert.date, @concert.start_time)
      @registered_concerts = Array(RegisteredConcert.where(concert_id: @concert.id).order("created_at ASC")) # TO/DO order by likes
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
      @artist = Artist.find_by(name: params[:concert][:artist_name])
      if !@artist
        artist_api = TicketmasterService.artists_by_name(params[:concert][:artist_name])&.first
        @artist = Artist.get_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
      end
      @concert.artists << @artist if @artist
      @concert.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id)

      if @concert.save!
          redirect_to concert_path(@concert)
      else
          redirect_back fallback_location: root_path
      end
  end

  private

  def create_params
      params.require(:concert).permit(:date, :tour_name, :artist_id, :requesting_user_id, :status, :ubication_id)
  end 

end