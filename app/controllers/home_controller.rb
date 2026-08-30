class HomeController < ApplicationController

  def index
    
    @artists = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC").first(10)
    events_api = TicketmasterService.events_by(query: nil, artist_id: nil, first_date: nil, second_date: nil, country_code: current_user&.ubication&.country&.code, size: 8)
    events_db = Event.accepted.search_by({ country: current_user&.ubication&.country&.code, first_date: Date.today }, events_api)
    @events = TicketmasterService.merge_events(events_db, events_api)
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(10)

    if current_user
      @registers = Register.viewables(current_user).where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
    end

    @registers = Register.viewables(current_user).order("created_at DESC") if !@registers.present? || @registers.empty?
    
  end

end
