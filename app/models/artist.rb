class Artist < ApplicationRecord

  ##CONFIGURATIONS

    extend ApplicationHelper
    require "open-uri" #used to open a photo from a url (save the one from ticketmaster url)

    kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## CALLBACKS

    before_destroy :destroy_orphan_events #before the associations line

  ## RELATIONSHIPS

    belongs_to :genre, optional: true
    belongs_to :requester, class_name: "User", optional: true

    has_many :artists_events, dependent: :destroy
    has_many :events, through: :artists_events, dependent: :destroy
    has_many :relations, as: :followed, dependent: :destroy
    has_many :followers, through: :relations, source: :follower
    
    has_one_attached :photo
    
  ## SCOPES

    scope :by_name, -> (query) { where("name ILIKE :q", q: "%#{query}%") }
    scope :by_genre, ->(genre_id) { where(genre_id: genre_id ) }
    scope :accepted, -> { where(status: 0).or(where(status: nil)) }
    scope :pending, -> { where(status: 1) }
    scope :manually_added, -> { where( ticketmaster_id: nil ) }
    scope :most_followed, -> { left_joins(:relations).group(:id).order("COUNT(relations.id) DESC") }
    
  ## VALIDATIONS

    validates :name, presence: true
    validates :ticketmaster_id, uniqueness: { allow_nil: true }

  ## CALLBACKS METHODS
  
    def destroy_orphan_events
      events.each do |event|
        event.destroy if event.artists.where.not(id: id).empty?
      end
    end
    
  ## CLASS METHODS

    def self.create_or_update_by_ticketmaster_id(id)
      artist = Artist.find_or_initialize_by(ticketmaster_id: id)
      if artist.new_record? || artist.updated_at < 5.hours.ago
        artist_api = TicketmasterService.artist_by_id(id)
        return if artist_api.nil? #there are events with nil artist associated in ticketmaster
        
        artist.name = artist_api.dig("name")
        artist.genre = Genre.find_by(name: artist_api.dig("classifications", 0, "genre", "name"))
        
        if artist.new_record?
          if artist_api.dig("images").present?
            image = best_quality_image(artist_api.dig("images"))
            artist.photo.attach(io: URI.open(image.dig("url")), filename: image.dig("url"), content_type: "image/jpg")
          end
        end
        artist.save!
        artist.touch # updates "updated_at" field
      end 
      return artist
    end

    def self.search_by(params, artists_api)      
      artists = Artist.accepted
      artists = artists.by_name(params[:search]) if params[:search].present?
      artists = artists.by_genre(Genre.find(params[:genre_id]).id) if params[:genre_id].present?

      # exclude ticketmaster ids
      ticketmaster_ids = artists_api.map { |artist| artist["id"] }
      artists = artists.where(ticketmaster_id: nil).or(artists.where.not(ticketmaster_id: ticketmaster_ids))

      artists
    end
          
  ## INSTANCE METHODS

    def complete_name
      name
    end

    def registers
      Register.by_artist(self.id)
    end

    def publications
      Publication.by_artist(self.id)
    end

    def average_rating
      registers.average(:rating).to_i || 0
    end

    def follow(user_id)
      Relation.find_or_create_by!(follower_id: user_id, followed_id: self.id, followed_type: "Artist", relation_type: 0)
    end

    def unfollow(user_id)
      Relation.find_by(follower_id: user_id, followed_id: self.id, followed_type: "Artist", relation_type: 0)&.destroy
    end

    def mark_as_favorite(user)
      FavoriteArtist.find_or_create_by!(user_id: user.id, artist_id: self.id) if user.can_mark_favorite?
    end

    def unmark_as_favorite(user_id)
      FavoriteArtist.find_by(user_id: user_id, artist_id: self.id)&.destroy
    end

    def accepted?
      !manually_added || (!status.nil? && status == 0)
    end

    def manually_added
      ticketmaster_id.nil?
    end

end