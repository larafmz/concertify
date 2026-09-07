class FutureAssistancesController < ApplicationController
    
    load_and_authorize_resource

    def new
        if params[:ticketmaster_id]
            @event = Event.find_by(ticketmaster_id: params[:ticketmaster_id])
            @event_api = TicketmasterService.event_by_id(params[:ticketmaster_id]) if @event.nil?
        else
            @event = Event.find(params[:event_id])
        end
        @future_assistance = FutureAssistance.new
        render layout: false
    end

    def create
        @future_assistance = FutureAssistance.new(create_params)

        unless params[:ticketmaster_id].blank?
            @event = Event.create_or_update_by_ticketmaster_id(params[:ticketmaster_id])
            @future_assistance.event_id = @event.id
        end

        @future_assistance.save!
        redirect_back fallback_location: root_path

    end

    def edit
        @event = Event.find(@future_assistance.event_id)
        render layout: false
    end

    def update
        @event = Event.find(@future_assistance.event_id)

        if @future_assistance.update(create_params)
            redirect_back fallback_location: root_path
        else
            redirect_back fallback_location: root_path
        end
    end

    def destroy
        future_assistance_id = @future_assistance.id
        if @future_assistance.destroy
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.remove("future-assistance-#{future_assistance_id}") }
                format.html { redirect_back fallback_location: root_path }
            end
        end
    end

private

    def create_params
        params.require(:future_assistance).permit(:event_id, :user_id, :company, :from, :event_seat, :event_seat_details)
    end 

end