class RegisteredConcertsController < ApplicationController
  
def new
  @concert = Concert.get_or_create_by_id(params[:concert_id])
  @registered_concert = RegisteredConcert.new(concert_id: @concert.id)
  render layout: false
end


def create
    @registered_concert = RegisteredConcert.new(create_params)

    if @registered_concert.save
        puts "GUARDADO"
    else
        puts "ERROR"
    end
end

private

def create_params
    puts "DEBAJO"
    puts params
    params.require(:registered_concert).permit(:concert_id, :text, :user_id, :puntuation)
end 

end