class FutureAssistancesController < ApplicationController
  
def index
    if params[:user_id]
        @future_assistances = FutureAssistance.joins(:concert).where(user_id: params[:user_id]).order("concerts.date ASC")
        @user = User.find(params[:user_id])
    elsif params[:concert_id]
        @future_assistances = FutureAssistance.where(concert_id: params[:concert_id]).order("created_at DESC")
        @concert = Concert.find(params[:concert_id])
    end
end

def new
    if params[:ticketmaster_id]
        @concert = Concert.find_by(ticketmaster_id: params[:ticketmaster_id]) if 
        @concert_api = TicketmasterService.concert_by_id(params[:ticketmaster_id]) if @concert.nil?
    else
        @concert = Concert.find(params[:concert_id])
    end
    @future_assistance = FutureAssistance.new
    render layout: false
end

def create
    @future_assistance = FutureAssistance.new(create_params)

    if !params[:ticketmaster_id].empty?
        @concert = Concert.get_by_ticketmaster_id(params[:ticketmaster_id])
        @future_assistance.concert_id = @concert.id
    end

    @future_assistance.save!
    redirect_back fallback_location: root_path

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
    params.require(:future_assistance).permit(:concert_id, :user_id, :company, :from, :concert_seat, :concert_seat_details)
end 

end