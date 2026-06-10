class FutureAssistancesController < ApplicationController
  
def new
  @concert = Concert.find_by(ticketmaster_id: params[:concert_id])
  @concert_api = TicketmasterService.concert_by_id(params[:concert_id]) if @concert.nil?
  @future_assistance = FutureAssistance.new()
  render layout: false
end

def create
    @concert = Concert.get_or_create_by_id(params[:future_assistance][:concert_id])
    @future_assistance = FutureAssistance.new(create_params)
    @future_assistance.concert_id = @concert.id

    if @future_assistance.save
        redirect_to future_assistance_path(@future_assistance)
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

    if @future_assistance.update(create_params)
        redirect_to future_assistance_path(@future_assistance)
    else
        redirect_back fallback_location: root_path
    end
end

private

def create_params
    params.require(:future_assistance).permit(:concert_id, :user_id, :alone, :from, :concert_seat, :concert_seat_details)
end 

end