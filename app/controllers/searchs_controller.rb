class SearchsController < ApplicationController

  def index
    query = params[:search]
    @users = User.where("email ILIKE ?", "%#{query}%")
    @artists = Artist.where("name ILIKE ?", "%#{query}%")
    @concerts = Concert.left_joins(:artist).where("concerts.tour_name ILIKE :q OR artists.name ILIKE :q", q: "%#{query}%").order(date: :desc)
  end

end
