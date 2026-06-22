include ApplicationHelper

class Artist < ApplicationRecord

  ## RELATIONSHIPS

    has_many :artists_concerts
    has_many :concerts, through: :artists_concerts
    has_one_attached :photo
    has_many :publications
    belongs_to :genre, optional: true

  ## SCOPES

    scope :by_name, -> (query) { where("name ILIKE :q", q: "%#{query}%") }
    
  ## VALIDATIONS

    validates :name, :ticketmaster_id, presence: true
    validates :ticketmaster_id, uniqueness: true
    
  ## CLASS METHODS

    def self.get_or_create_by_id(id)
      artist = Artist.find_or_create_by!(ticketmaster_id: id) do |a|
        artist_api = TicketmasterService.artist_by_id(id)
        return if artist_api.nil? #there are concerts with nil artist associated in ticketmaster
        a.name = artist_api.dig("name")
        if artist_api.dig("images").present?
          image = best_quality_image(artist_api.dig("images"))
          a.photo.attach(io: URI.open(image.dig("url")), filename: image.dig("url"), content_type: "image/jpg")
        end
        a.genre = Genre.find_by(name: artist_api.dig("classifications", 0, "genre", "name"))
      end 
      return artist
    end
          
  ## INSTANCE METHODS

    def complete_name
      name
    end

    def registered_concerts
      RegisteredConcert.by_artist(self.id)
    end

    def average_puntuation
      registered_concerts.average(:puntuation).to_i || 0
    end

    def search_concerts_by(first_date, second_date, country_code, concerts_api)
      concerts_db = self.concerts
      ticketmaster_ids = concerts_api.map { |concert| concert["id"] }
      concerts_db = concerts_db.where.not(ticketmaster_id: ticketmaster_ids).order(date: :asc)
      if first_date.present? || second_date.present?
        first_date = Date.parse(first_date) if first_date && !first_date.empty?
        second_date = Date.parse(second_date) if second_date && !second_date.empty?
        second_date = first_date if !second_date.present?
        first_date ||= Date.today
        concerts_db = concerts_db.where("date >= ?", first_date)
        concerts_db = concerts_db.where("date <= ?", second_date)
      end
      concerts_db = concerts_db.by_country_code(country_code) if country_code.present?
      concerts_db
    end

end