include ApplicationHelper

class Artist < ApplicationRecord

  ## RELATIONSHIPS

    has_many :concerts
    has_many_attached :photos
    has_many :interactuables
    belongs_to :genre, optional: true

  ## VALIDATIONS

    validates :name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true
    
  ## INSTANCE METHODS

    def complete_name
      name
    end

    def average_puntuation
      interactuables.publication.average(:puntuation) || 0
    end

    def self.get_or_create_by_id(id)
      artist = Artist.find_or_create_by!(ticketmaster_id: id) do |a|
        artist_api = TicketmasterService.artist_by_id(id)
        a.name = artist_api.dig("name")
        if artist_api.dig("images").present?
          image = best_quality_image(artist_api.dig("images"))
          a.photos.attach(io: URI.open(image.dig("url")), filename: image.dig("url"), content_type: "image/jpg")
        end
        a.genre = Genre.find_by(name: artist_api.dig("classifications", 0, "genre", "name"))
      end 
      return artist
    end

end