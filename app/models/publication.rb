class Publication < Interactuable

  ## CONFIGURATIONS

   MAX_PHOTOS = 4

  ## RELATIONSHIPS
    
    belongs_to :artist, optional: true
    belongs_to :event, optional: true
    
  ## VALIDATIONS
    
    validates :review, presence: true
    validate :photos_limit

  ## SCOPES

    scope :by_artist, -> (artist_id) { left_joins(:artist).where(artist: { id: artist_id }) }
    scope :of_user_followings, -> (user) { where(user_id: user.followings.users.select(:followed_id)).or(where(artist_id: user.followings.artists.select(:followed_id))) }
    scope :of_user_events, -> (user) { where(event_id: user.registers.select(:event_id)).or(where(event_id: user.future_assistances.select(:event_id))) }
  
  ## VALIDATION METHODS

  private

    def photos_limit
        if photos.attached? && photos.count > MAX_PHOTOS
            errors.add(:photos, I18n.t("messages.max_upload", count: MAX_PHOTOS))
        end
    end

  ## CLASS METHODS

    def self.feed(user)
      return Publication.all unless user.present?

      reposts = Repost.for_publications.where(user_id: [user.id, *user.following_ids]).includes(:interactuable, :user)
      publis = Publication.where(user_id: user.id).or(Publication.of_user_followings(user)).or(Publication.of_user_events(user)).distinct
      publis = publis.where.not(id: reposts.pluck(:interactuable_id)) # Exclude publications that have been reposted by the user or their followings

      feed = (publis.viewables(user).map do |publi|
        {
          publication: publi,
          repost: nil,
          date: publi.created_at
        }
        end + reposts.map do |repost|
        {
          publication: repost.interactuable,
          repost: repost,
          date: repost.created_at
        }
      end).sort_by { |obj| -obj[:date].to_i }
      feed
    end

    def self.viewables(user)
      if user.present?
        #Remove Publications from users than have BLOCKED ME
        pub = Publication.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove Publications from users than I HAVE BLOCKED
        pub.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        Publication.all
      end
    end

end