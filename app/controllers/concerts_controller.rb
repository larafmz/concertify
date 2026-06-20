class ConcertsController < ApplicationController
  include ApplicationHelper

  def show
    
    @concert = Concert.get_or_create_by_id(params[:ticketmaster_id]) if params[:ticketmaster_id].present?
    @concert = Concert.find(params[:id]) if @concert.nil?
    if @concert
      @concert_date_status = time_status(@concert.date, @concert.start_time)
      @registered_concerts = Array(RegisteredConcert.where(concert_id: @concert.id).order("created_at ASC")) # TO/DO order by likes
      @registered_concerts = Array(RegisteredConcert.all) # TO/DO order by likes
    else
      # TO/DO redirigir o error...
    end
  end

end