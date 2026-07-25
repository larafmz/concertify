class FutureAssistancesController < ApplicationController

def new
    if params[:ticketmaster_id]
        @event = Event.find_by(ticketmaster_id: params[:ticketmaster_id]) if 
        @event_api = TicketmasterService.event_by_id(params[:ticketmaster_id]) if @event.nil?
    else
        @event = Event.find(params[:event_id])
    end
    @future_assistance = FutureAssistance.new
    render layout: false
end

def create
    @future_assistance = FutureAssistance.new(create_params)

    if !params[:ticketmaster_id].empty?
        @event = Event.get_by_ticketmaster_id(params[:ticketmaster_id])
        @future_assistance.event_id = @event.id
    end

    @future_assistance.save!
    redirect_back fallback_location: root_path

end

def edit
    @future_assistance = FutureAssistance.find(params[:id])
    @event = Event.find(@future_assistance.event_id)
    render layout: false
end

def update
    @future_assistance = FutureAssistance.find(params[:id])
    @event = Event.find(@future_assistance.event_id)

    if @future_assistance.update!(create_params)
        redirect_back fallback_location: root_path
    else
        redirect_back fallback_location: root_path
    end
end

def destroy
    @future_assistance = FutureAssistance.find(params[:id])
    @future_assistance.destroy
    redirect_back fallback_location: root_path
end

private

def create_params
    params.require(:future_assistance).permit(:event_id, :user_id, :company, :from, :event_seat, :event_seat_details)
end 

end