class HomeController < ApplicationController

  def index
    @artists = Artist.accepted.left_joins(:relations).group(:id).order("COUNT(relations.id) DESC").first(10)
    @registers = Register.feed(current_user).first(10)
    @publications = Publication.feed(current_user).first(5)
  end

end
