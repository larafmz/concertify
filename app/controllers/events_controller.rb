class EventsController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource except: [:show]

  before_action :get_attributes, except: [:new, :create, :requests, :index]

  def index
    events = Event.search_by(params: params)
    @events = Kaminari.paginate_array(events).page(params[:page]).per(10)
  end

  def show
    @event = Event.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @event = Event.accepted.find_by(id: params[:artist_id] || params[:id]) unless @event
    
    if @event.present?
      @artists = @event.artists
      get_attributes
    else
      redirect_back fallback_location: root_path
    end
    
  end

  def future_assistances
    @froms_filters = @event.future_assistances.map(&:from).compact.reject(&:empty?).uniq.sort_by(&:downcase)
    future_assistances = FutureAssistance.search_by(current_user, params: params, event_id: @event)
    @future_assistances = future_assistances.page(params[:page]).per(10)
    @pagination_path =  request.query_parameters.merge( controller: "events", action: "future_assistances", event_id: @event.id )
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def registers
    @registers = @registers.page(params[:page]).per(5)
    @pagination_path = request.query_parameters.merge( controller: "events", action: "registers", event_id: @event.id )
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def publications
    @publications = @publications.page(params[:page]).per(10)
    @pagination_path = request.query_parameters.merge( controller: "events", action: "publications", event_id: @event.id )
    respond_to do |format|
        format.html
        format.turbo_stream
    end
  end

  def post
    @publication = Publication.create!(event_id: params[:id], user_id: current_user&.id, review: params[:text])
    redirect_to interactuable_path(@publication)
  end

  private

  def get_attributes  
    if @event
      @registers = @event.registers.viewables(current_user).order("created_at DESC")
      @publications = @event.publications.viewables(current_user).order("created_at DESC")
      @event_future_assistances_count = @event.future_assistances.count
      @average_rating = @event.average_rating
      @event_registers_count = @event.registers.viewables(current_user).size
      @event_publications_count = @event.publications.viewables(current_user).size
      photo = @event.get_photo
      @photo_url = photo ? url_for(photo) : ActionController::Base.helpers.asset_path("default-event.jpg")
    end
  end


end