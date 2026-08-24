class RequestsController < ApplicationController

    load_and_authorize_resource

    def index
        @requests = Request.order("created_at DESC")
    end

    def new
        @request = Request.new
        @event = @request.event || @request.build_event
        render layout: false
    end

    def create
        @request = Request.new(create_params)     
        @event = @request.event

        # Search artist in DB
        @artist = Artist.find_by(name: params[:request][:event_attributes][:artist_name])
        # Search artist in Ticketmaster
        if !@artist
            artist_api = TicketmasterService.artists_by(params[:request][:event_attributes][:artist_name], nil)&.first
            @artist = Artist.create_or_update_by_ticketmaster_id(artist_api&.dig("id")) if artist_api
        end
        #Create artist with status pending
        @artist = Artist.create(name: params[:request][:event_attributes][:artist_name], requester_id: current_user&.id, status: 1) if !@artist
        
        @event.artists << @artist
        @event.ubication = Ubication.create(country_id: Country.find_by(code: params[:country])&.id, city: params[:city])

        if @event.save!
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
        @artist = Artist.find_by(name: params[:event_attributes][:artist_name])
        if !@artist
            artist_api = TicketmasterService.artists_by(params[:event_attributes][:artist_name], nil)&.first
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
        @request.destroy
        redirect_back fallback_location: root_path
    end

private

    def create_params
        params.require(:request).permit(:requester_id, :status, event_attributes: [:date, :tour_name, :artist_id, :ubication_id])
    end 

end