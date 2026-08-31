class RegistersController < ApplicationController
  
  load_and_authorize_resource

    def index
        registers = Register.viewables(current_user)
        @registers = Kaminari.paginate_array(registers).page(params[:page]).per(5)
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end

    def new
        if params[:ticketmaster_id]
            @event = Event.find_by(ticketmaster_id: params[:ticketmaster_id])
            @event_api = TicketmasterService.event_by_id(params[:ticketmaster_id]) if @event.nil?
        else
            @event = Event.find(params[:event_id])
        end
    @register = Register.new
    render layout: false
    end

    def create
        @register = Register.new(create_params)

        unless params[:ticketmaster_id].blank?
            @event = Event.create_or_update_by_ticketmaster_id(params[:ticketmaster_id]) 
            @register.event_id = @event.id if @event
        end
        
        ActiveRecord::Base.transaction do
            if @register.save
                future_assistance = FutureAssistance.find_by(event_id: @register.event_id, user_id: current_user&.id)
                future_assistance.destroy if future_assistance
                redirect_back fallback_location: root_path
            else
                redirect_back fallback_location: root_path
            end
        end
    end

    def edit
        @register = Register.find(params[:id])
        @event = Event.find(@register.event_id)
        render layout: false
    end

    def update
        @register = Register.find(params[:id])
        @event = Event.find(@register.event_id)

        if @register.update(create_params)
            redirect_back fallback_location: root_path
        else
            redirect_back fallback_location: root_path
        end
    end

private

    def create_params
        params.require(:register).permit(:event_id, :review, :user_id, :rating)
    end 

end