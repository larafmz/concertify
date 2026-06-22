class HomeController < ApplicationController

  def index
    
    @artists_db = Artist.all
    @concerts_db = Concert.accepted.order("created_at DESC")
  

  end

end
