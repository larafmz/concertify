class EventsController < ApplicationController
  include ApplicationHelper

  authorize_resource

  before_action :set_artist, except: [:show, :new, :create, :requests, :index]

  def index
    events_api = TicketmasterService.events_by(query: params[:search], artist_id: params[:ticketmaster_id], first_date: params[:first_date], second_date: params[:second_date], country_code: params[:country], size: 100) 
    # el tamaño de la consulta afecta a los resultados, x eso aqui sale alguno diferentes que en home
    events_db = Event.search_by(params[:search], params[:first_date], params[:second_date], params[:country], events_api)
    @events = TicketmasterService.merge_events(events_db, events_api)
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
    else
      redirect_back fallback_location: root_path
    end
    
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
    @event = Event.find_by(id: params[:id])    
    unless @event
      flash[:alert] = t("not_found_masc", model: Event.singular.downcase)
      redirect_back fallback_location: root_path
      return
    end
    @future_assistances = @event.future_assistances.viewables(current_user).order("created_at DESC")
    @registers = @event.registers.viewables(current_user).order("created_at DESC")
    @publications = @event.publications.viewables(current_user).order("created_at DESC")
  end


end