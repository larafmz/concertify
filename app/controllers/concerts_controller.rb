class ConcertsController < ApplicationController
  include ApplicationHelper

  def show
    @concert = Concert.find(params[:id])
  end

end