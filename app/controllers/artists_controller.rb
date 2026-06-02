class ArtistsController < ApplicationController
  include ApplicationHelper

  def show
    @artist = Artist.find_by(ticketmaster_id: params[:id])

    if @artist.nil?
      artist_api = TicketmasterService.artists_by_id(params[:id])
      @artist = Artist.create!(ticketmaster_id: params[:id], name: artist_api.dig("name")) do |a|
        if artist_api.dig("images").present?
          image = best_quality_image(artist_api.dig("images"))
          a.photos.attach(io: URI.open(image.dig("url")), filename: image.dig("url"), content_type: "image/jpg")
        end
        a.genre = Genre.find_by(name: artist_api.dig("classifications", 0, "genre", "name"))
      end 
    end

    @concerts_api = TicketmasterService.concerts_by_artist_id(params[:id]) || []

  end

end