class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC")
    @concerts = Concert.accepted.where("date >= ?", Date.today).order("date ASC")

    if current_user
      artist_ids = current_user.followings.artists.pluck(:followed_id)
      @concerts = @concerts.joins(:artists).where(artists: { id: artist_ids }).distinct
      @concerts_close = @concerts.by_country_code(current_user.ubication&.country.code) 
      @registers = Register.all.where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
      @publications = Publication.all.where(user_id: current_user.followings.users.pluck(:followed_id)).order("created_at DESC")
    end

    @registers = Register.all.order("created_at DESC") if !@registers.present? || @registers.empty?
    @publications = Publication.all.order("created_at DESC") if !@publications.present? || @publications.empty?


  end

end
