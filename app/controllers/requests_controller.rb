class RequestsController < ApplicationController

    load_and_authorize_resource

    def index
        @requests = Request.do_search(params)
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
        if !@artist
            artist_api = TicketmasterService.artists_by(params[:request][:event_attributes][:artist_name])&.first
            @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
        end
        #Create artist with status pending
        @artist = Artist.create(name: params[:request][:event_attributes][:artist_name], status: 1) if !@artist
        
        @event.artists << @artist

        if @request.save!
            redirect_to requests_user_path(current_user)
        else
            redirect_back fallback_location: root_path
        end
    end

    def edit   
        @event = @request.event
        render layout: false
    end

    def update
        @event = @request.event

        @artist = Artist.find_by(name: params[:request][:event_attributes][:artist_name])
        if !@artist
            artist_api = TicketmasterService.artist_by_name(params[:request][:event_attributes][:artist_name])
            @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
        end
        #Create artist with status pending and delete the old artist if needed
        if !@artist
            old_artist = @event.artists.first 
            old_artist.destroy if  old_artist.events.count==1 && !old_artist.accepted?
            @artist = Artist.create(name: params[:request][:event_attributes][:artist_name], status: 1) if !@artist
        end

        @event.artists = [@artist] if @artist

        @request.update(create_params)
        redirect_back fallback_location: root_path
        
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