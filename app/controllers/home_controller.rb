class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.accepted
    @concerts_db = Concert.accepted.order("created_at DESC")

    if current_user && !current_user.followings.artists.empty?
      artist_ids = current_user.followings.artists.pluck(:followed_id)
      @concerts_following_db = Concert.accepted.joins(:artists).where(artists: { id: artist_ids }).distinct
    end


  end

end
