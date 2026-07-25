class RegistersController < ApplicationController
  
def index
    @registers = Register.viewables(current_user).order("created_at DESC") if @registers.nil?
end

def new
    if params[:ticketmaster_id]
        @concert = Concert.find_by(ticketmaster_id: params[:ticketmaster_id]) if 
        @concert_api = TicketmasterService.concert_by_id(params[:ticketmaster_id]) if @concert.nil?
    else
        @concert = Concert.find(params[:concert_id])
    end
  @register = Register.new
  render layout: false
end

def create
    @register = Register.new(create_params)

    if !params[:ticketmaster_id].empty?
        @concert = Concert.get_by_ticketmaster_id(params[:ticketmaster_id]) 
        @register.concert_id = @concert.id if @concert
    end
    
    ActiveRecord::Base.transaction do
        if @register.save!
            future_assistance = FutureAssistance.find_by(concert_id: @register.concert_id, user_id: current_user.id)
            future_assistance.destroy if future_assistance
            redirect_to interactuable_path(@register)
        else
            redirect_back fallback_location: root_path
        end
    end
end

def edit
    @register = Register.find(params[:id])
    @concert = Concert.find(@register.concert_id)
    render layout: false
end

def update
    @register = Register.find(params[:id])
    @concert = Concert.find(@register.concert_id)

    if @register.update!(create_params)
        redirect_back fallback_location: root_path
    else
        redirect_back fallback_location: root_path
    end
end

def destroy
  @register = Register.find(params[:id])
  @register.destroy
  redirect_to root_path
end

private

    def create_params
        params.require(:register).permit(:concert_id, :review, :user_id, :rating)
    end 

end