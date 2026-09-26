class RequestsController < ApplicationController

    load_and_authorize_resource

    def index
        requests = Request.do_search(params)        
        @requests = requests.page(params[:page]).per(5)
        @pagination_path = request.query_parameters.merge( controller: "requests", action: "index" )
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
        @request.create_artists(params[:request][:event_attributes][:artist_name])

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
        @request.create_artists(params[:request][:event_attributes][:artist_name])
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
        request_id = @request.id
        if @request.destroy
            render turbo_stream: turbo_stream.remove("request-#{request_id}")
        end
    end

private

    def create_params
        params.require(:request).permit(:requester_id, :status, :message, :existing_event_id, event_attributes: [:id, :start_time, :date, :tour_name, :artist_id, ubication_attributes: [:id, :city, :venue, :country_id] ])
    end 

end