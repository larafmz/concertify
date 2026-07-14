class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC")
    @concerts_db = Concert.accepted.where("date >= ?", Date.today).order("date ASC")

    if current_user
      artist_ids = current_user.followings.artists.pluck(:followed_id)
      @concerts_db = @concerts_db.joins(:artists).where(artists: { id: artist_ids }).distinct
      @registers = RegisteredConcert.all.where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
    end

    @registers = RegisteredConcert.all.order("created_at DESC") if @registers || @registers.empty?


  end

end
