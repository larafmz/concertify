class EventsController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource except: [:show]

  before_action :get_attributes, except: [:new, :create, :requests, :index]

  def index
    events_api = TicketmasterService.events_by(query: params[:search], artist_id: params[:ticketmaster_id], first_date: params[:first_date], second_date: params[:second_date], country_code: params[:country], size: 100) 
    # el tamaño de la consulta afecta a los resultados, x eso aqui sale alguno diferentes que en home
    events_db = Event.search_by(params, events_api)
    @events = TicketmasterService.merge_events(events_db, events_api)
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(10)
    
  end

  def show
    if params[:ticketmaster_id].present?
      @event = Event.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    elsif params[:id]
      @event = Event.accepted.find_by(id: params[:id])
      @event = Event.create_or_update_by_ticketmaster_id(@event.ticketmaster_id) if !params[:ticketmaster_id].present? && @event&.ticketmaster_id
    end

    if @event
      @artists = @event.artists
      get_attributes
    else
      redirect_back fallback_location: root_path
    end
    
  end

  def future_assistances
  end

  def registers
  end

  def publications
    @publications = @publications.page(params[:page]).per(10)
    @pagination_path = { controller: "events", action: "publications", event_id: @event.id }
    respond_to do |format|
        format.html
        format.turbo_stream
    end
  end

  def post
    Publication.create!(event_id: params[:id], user_id: current_user&.id, review: params[:text])
    redirect_to publications_event_path(@event)
  end

  private

  def get_attributes  
    if @event
      @future_assistances = @event.future_assistances.viewables(current_user).order("created_at DESC")
      @registers = @event.registers.viewables(current_user).order("created_at DESC")
      @publications = @event.publications.viewables(current_user).order("created_at DESC")
      @future_assistances_count = @event.future_assistances.count
      @average_rating = @event.average_rating
      @event_registers_count = @event.registers.viewables(current_user).size
      @event_publications_count = @event.publications.viewables(current_user).size
    end
  end


end