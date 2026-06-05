class FutureAssistancesController < ApplicationController
  
def new
  @concert = Concert.get_or_create_by_id(params[:concert_id])
  @future_assistance = FutureAssistance.new(concert_id: @concert.id)
  render layout: false
end

def create
    @future_assistance = FutureAssistance.new(create_params)
    @concert = Concert.find(@future_assistance.concert_id)

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