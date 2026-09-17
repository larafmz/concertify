class HomeController < ApplicationController

  def index
    
    @artists = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC").first(10)
    events = Event.accepted.search_by(params: { country: current_user&.ubication&.country&.code, first_date: Date.today })
    @events = Kaminari.paginate_array(events).page(params[:page]).per(10)
    @registers = Register.feed(current_user).first(6)
  end

end
