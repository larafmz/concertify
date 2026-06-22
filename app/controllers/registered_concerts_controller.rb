class RegisteredConcertsController < ApplicationController
  
def index
    @registered_concerts = RegisteredConcert.joins(:concert).where(user_id: current_user.id).order("concerts.date DESC")
end

def show
    @register = RegisteredConcert.find(params[:id])
    @concert = Concert.find(@register.concert_id)
    @artist = Artist.find(@concert.artists.first.id)
end

def new
    if params[:ticketmaster_id]
        @concert = Concert.find_by(ticketmaster_id: params[:ticketmaster_id]) if 
        @concert_api = TicketmasterService.concert_by_id(params[:ticketmaster_id]) if @concert.nil?
    else
        @concert = Concert.find(params[:concert_id])
    end
  @registered_concert = RegisteredConcert.new
  render layout: false
end

def create
    @registered_concert = RegisteredConcert.new(create_params)

    if !params[:ticketmaster_id].empty?
        @concert = Concert.get_by_ticketmaster_id(params[:ticketmaster_id]) 
        @registered_concert.concert_id = @concert.id if @concert
    end
    
    ActiveRecord::Base.transaction do
        if @registered_concert.save!
            future_assistance = FutureAssistance.find_by(concert_id: @registered_concert.concert_id, user_id: current_user.id)
            future_assistance.destroy if future_assistance
            redirect_to registered_concert_path(@registered_concert)
        else
            redirect_back fallback_location: root_path
        end
    end
end

def edit
    @registered_concert = RegisteredConcert.find(params[:id])
    @concert = Concert.find(@registered_concert.concert_id)
    render layout: false
end

def update
    @registered_concert = RegisteredConcert.find(params[:id])
    @concert = Concert.find(@registered_concert.concert_id)

    if @registered_concert.update!(create_params)
        redirect_back fallback_location: root_path
    else
        redirect_back fallback_location: root_path
    end
end

def destroy
  @register = RegisteredConcert.find(params[:id])
  @register.destroy
  redirect_to root_path
end

private

def create_params
    params.require(:registered_concert).permit(:concert_id, :text, :user_id, :puntuation)
end 

end