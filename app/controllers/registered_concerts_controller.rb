class RegisteredConcertsController < ApplicationController
  
def index
    @registered_concerts = RegisteredConcert.joins(:concert).where(user_id: params[:user_id]).order("concerts.date DESC")
end

def new
  @concert = Concert.find_by(ticketmaster_id: params[:concert_id])
  @concert_api = TicketmasterService.concert_by_id(params[:concert_id]) if @concert.nil?
  @registered_concert = RegisteredConcert.new
  render layout: false
end

def create
    @concert = Concert.get_or_create_by_id(params[:registered_concert][:concert_id])
    @registered_concert = RegisteredConcert.new(create_params)
    @registered_concert.concert_id = @concert.id

    if @registered_concert.save!
        redirect_back fallback_location: root_path
    else
       redirect_back fallback_location: root_path
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

def show
    @register = RegisteredConcert.find(params[:id])
    @concert = Concert.find(@register.concert_id)
    @artist = Artist.find(@concert.artist_id)
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