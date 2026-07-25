class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC")

    events_api = TicketmasterService.recent_events(current_user.ubication&.country&.code)
    events_db = Event.accepted.search_by(nil, Date.today, nil, nil, events_api)
    @events = TicketmasterService.merge_events(events_db, events_api)

    if current_user
      @registers = Register.viewables(current_user).where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
      @publications = Publication.viewables(current_user).where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
    end

    @registers = Register.viewables(current_user).order("created_at DESC") if !@registers.present? || @registers.empty?
    @publications = Publication.viewables(current_user).order("created_at DESC") if !@publications.present? || @publications.empty?
    
  end

end
