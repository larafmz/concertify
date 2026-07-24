include ApplicationHelper

class Artist < ApplicationRecord

  ##CONFIGURATIONS

    kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## RELATIONSHIPS

    has_many :artists_concerts, dependent: :destroy
    has_many :concerts, through: :artists_concerts
    has_many :publications, dependent: :destroy
    belongs_to :genre, optional: true
    has_many :relations, as: :followed, dependent: :destroy
    has_one_attached :photo
    
  ## SCOPES

    scope :by_name, -> (query) { where("name ILIKE :q", q: "%#{query}%") }
    scope :by_genre, ->(genre_id) { where(genre_id: genre_id ) }
    scope :accepted, -> { where(status: 0).or(where(status: nil)) }
    scope :pending, -> { where(status: 1) }
    
  ## VALIDATIONS

    validates :name, presence: true
    validates :ticketmaster_id, uniqueness: { allow_nil: true }
    
  ## CLASS METHODS

    def self.get_by_ticketmaster_id(id)
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

    def self.search_by(name, genre_id)
      artists_db =  Artist.by_name(name)
      artists_db = artists_db.by_genre(params[:genre]) if params[:genre]
      artists_db
    end
          
  ## INSTANCE METHODS

    def complete_name
      name
    end

    def registers
      Register.by_artist(self.id)
    end

    def average_rating
      registers.average(:rating).to_i || 0
    end

    def search_concerts_by(first_date, second_date, country_code, concerts_api)
      concerts_db = self.concerts.accepted
      ticketmaster_ids = concerts_api.map { |concert| concert["id"] }
      concerts_db = concerts_db.where(ticketmaster_id: nil).or(concerts_db.where.not(ticketmaster_id: ticketmaster_ids)).order(date: :asc)
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

    def follow(user_id)
      Relation.find_or_create_by!(follower_id: user_id, followed_id: self.id, followed_type: "Artist", relation_type: 0)
    end

    def unfollow(user_id)
      Relation.find_by(follower_id: user_id, followed_id: self.id, followed_type: "Artist", relation_type: 0)&.destroy
    end

    def mark_as_favorite(user_id)
      FavoriteArtist.find_or_create_by!(user_id: user_id, artist_id: self.id)
    end

    def unmark_as_favorite(user_id)
      FavoriteArtist.find_by(user_id: user_id, artist_id: self.id)&.destroy
    end

    def accepted?
      status == 0 || status == nil
    end

    def status_string
      status ? get_status_name : "Aceptado"
    end

end