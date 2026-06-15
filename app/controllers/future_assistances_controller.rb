class FutureAssistancesController < ApplicationController
  
def index
    @future_assistances = FutureAssistance.joins(:concert).where(user_id: params[:user_id]).order("concerts.date ASC")
end

def new
  @concert = Concert.find_by(ticketmaster_id: params[:ticketmaster_id])
  @concert_api = TicketmasterService.concert_by_id(params[:ticketmaster_id]) if @concert.nil?
  @future_assistance = FutureAssistance.new
  render layout: false
end

def create
    @future_assistance = FutureAssistance.new(create_params)

    if !params[:ticketmaster_id].empty?
        @concert = Concert.get_or_create_by_id(params[:ticketmaster_id])
        @future_assistance.concert_id = @concert.id
    end

    if @future_assistance.save!
        redirect_to future_assistances_path(user_id: current_user.id)
    else
       redirect_back fallback_location: root_path
    end
end

def edit
    @future_assistance = FutureAssistance.find(params[:id])
    @concert = Concert.find(@future_assistance.concert_id)
    render layout: false
end

def update
    @future_assistance = FutureAssistance.find(params[:id])
    @concert = Concert.find(@future_assistance.concert_id)

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
    params.require(:future_assistance).permit(:concert_id, :user_id, :alone, :from, :concert_seat, :concert_seat_details)
end 

end