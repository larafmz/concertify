class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.all
    @concerts_db = Concert.accepted.order("created_at DESC")

    if current_user && !current_user.followings.artists.empty?
      @concerts_following_db = current_user.followings.artists.flat_map do |relation|
        Artist.find(relation.followed_id).concerts.accepted
      end
    end


  end

end
