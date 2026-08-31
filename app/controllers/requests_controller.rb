class RequestsController < ApplicationController

    load_and_authorize_resource

    def index
        requests = Request.do_search(params)        
        @requests = requests.page(params[:page]).per(5)
        @pagination_path = { controller: "requests", action: "index" }
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

    def new
        @request = Request.new
        @event = @request.event || @request.build_event
        @ubication = @event.ubication || @event.build_ubication
        render layout: false
    end

    def create
        @request = Request.new(create_params)     
        @event = @request.event

        # Search artist in DB
        @artist = Artist.find_by(name: params[:request][:event_attributes][:artist_name])
        # Search artist in Ticketmaster
        unless @artist
            artist_api = TicketmasterService.artist_by_name(params[:request][:event_attributes][:artist_name])&.first
            @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
        end
        #Create artist with status pending
        @artist = Artist.create(name: params[:request][:event_attributes][:artist_name], status: 1, requester_id: params[:request][:requester_id]) unless @artist
        
        @event.artists << @artist

        if @request.save
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, requests_user_path(current_user)) }
                format.html { redirect_to requests_user_path(current_user), status: :see_other }
            end
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit   
        @event = @request.event
        render layout: false
    end

    def update
        @event = @request.event

        @artist = Artist.find_by(name: params[:request][:event_attributes][:artist_name])
        unless @artist
            artist_api = TicketmasterService.artist_by_name(params[:request][:event_attributes][:artist_name])
            @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
        end
        #Create artist with status pending and delete the old artist if needed
        unless @artist
            old_artist = @event.artists.first 
            old_artist.destroy if old_artist && old_artist.events.count==1 && !old_artist.accepted?
            @artist = Artist.create(name: params[:request][:event_attributes][:artist_name], status: 1) unless @artist
        end

        @event.artists = [@artist] if @artist

        if @request.update(create_params)
            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: turbo_stream.action( :redirect, request.referer || requests_path)
                end
                format.html do
                    redirect_to request.referer || requests_path
                end
            end
        else
            render :new, status: :unprocessable_entity
        end
        
    end

    def destroy
        @request.destroy
        redirect_back fallback_location: root_path
    end

private

    def create_params
        params.require(:request).permit(:requester_id, :status, :message, :existing_event_id, event_attributes: [:id, :start_time, :date, :tour_name, :artist_id, ubication_attributes: [:id, :city, :venue, :country_id] ])
    end 

end