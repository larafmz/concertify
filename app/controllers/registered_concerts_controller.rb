class RegisteredConcertsController < ApplicationController
  
def new
  @concert = Concert.get_or_create_by_id(params[:concert_id])
  @registered_concert = RegisteredConcert.new(concert_id: @concert.id)
  render layout: false
end

def create
    @registered_concert = RegisteredConcert.new(create_params)
    @concert = Concert.find(@registered_concert.concert_id)

    if @registered_concert.save
        redirect_to registered_concert_path(@registered_concert)
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

    if @registered_concert.update(create_params)
        redirect_to registered_concert_path(@registered_concert)
    else
        redirect_back fallback_location: root_path
    end
end

private

def create_params
    params.require(:registered_concert).permit(:concert_id, :text, :user_id, :puntuation)
end 

end