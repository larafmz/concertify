class ConcertsController < ApplicationController
  include ApplicationHelper

  def show
    @concert = Concert.get_or_create_by_id(params[:id])
  end

end