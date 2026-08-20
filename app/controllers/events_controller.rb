class EventsController < ApplicationController
  include ApplicationHelper

  before_action :set_artist, except: [:show, :new, :create, :requested, :index]

  def index
    events_api = TicketmasterService.events_by(query: params[:search], artist_id: params[:ticketmaster_id], first_date: params[:first_date], second_date: params[:second_date], country_code: params[:country], size: 100) 
    # el tamaño de la consulta afecta a los resultados, x eso aqui sale alguno diferentes que en home
    events_db = Event.search_by(params[:search], params[:first_date], params[:second_date], params[:country], events_api)
    @events = TicketmasterService.merge_events(events_db, events_api)
  end

  def show
    if params[:ticketmaster_id].present?
      @event = Event.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    else
      @event = Event.accepted.find_by(id: params[:id])
      @event = Event.create_or_update_by_ticketmaster_id(@event.ticketmaster_id) if !params[:ticketmaster_id].present? && @event.ticketmaster_id
    end

    if @event
      @artists = @event.artists
    else
      redirect_back fallback_location: root_path
    end
    
  end

  def new
    @event = Event.new
    render layout: false
  end

  def create
      @event = Event.new(create_params)
      
      # Search artist in DB
      @artist = Artist.find_by(name: params[:event][:artist_name])
      # Search artist in Ticketmaster
      if !@artist
        artist_api = TicketmasterService.artists_by(params[:event][:artist_name], nil)&.first
        @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
      end
      #Create artist with status pending
      @artist = Artist.create(name: params[:event][:artist_name], requester_id: current_user&.id, status: 1) if !@artist
      
      @event.artists << @artist
      @event.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id, city: params[:city])

      if @event.save!
          redirect_to requests_users_path(current_user)
      else
          redirect_back fallback_location: root_path
      end
  end

  def edit
    render layout: false
  end

  def update
      @artist = Artist.find_by(name: params[:event][:artist_name])
      if !@artist
        artist_api = TicketmasterService.artists_by(params[:event][:artist_name], nil)&.first
        @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
      end
      @event.artists = [@artist] if @artist
      @event.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id, city: params[:city])

      if @event.update(create_params)
          redirect_to requests_user_path(current_user)
      else
          redirect_back fallback_location: root_path
      end
  end

  def destroy
    if @event.requester_id == current_user&.id && @event.pending? #TO/DO or admin
      @event.destroy
    end
    redirect_back fallback_location: root_path
  end
  
  def requested
    #TO/DO if role admin, show all requesteds
  end

  def future_assistances
  end

  def registers
  end

  def publications
  end

  def post
    Publication.create!(event_id: params[:id], user_id: current_user&.id, review: params[:text])
    redirect_to publications_event_path(@event)
  end 

  private

  def set_artist
    @event = Event.find(params[:id])    
    @future_assistances = @event.future_assistances.viewables(current_user).order("created_at DESC")
    @registers = @event.registers.viewables(current_user).order("created_at DESC")
    @publications = @event.publications.viewables(current_user).order("created_at DESC")
  end

  def create_params
      params.require(:event).permit(:date, :tour_name, :artist_id, :requester_id, :status, :ubication_id)
  end 

end