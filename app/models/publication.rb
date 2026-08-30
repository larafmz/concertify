class Publication < Interactuable

  ## RELATIONSHIPS
    
    belongs_to :artist, optional: true
    belongs_to :event, optional: true
    
  ## VALIDATIONS
    
    validates :review, presence: true

  ## SCOPES

    scope :by_artist, -> (artist_id) { left_joins(:artist).where(artist: { id: artist_id }) }
    scope :of_user_followings, -> (user) { where(user_id: user.followings.users.select(:followed_id)).or(where(artist_id: user.followings.artists.select(:followed_id))) }
    scope :of_user_events, -> (user) { where(event_id: user.registers.select(:event_id)).or(where(event_id: user.future_assistances.select(:event_id))) }

  ## CLASS METHODS

    def self.search_by(user)
      return Publication.all unless user.present?
      Publication.where(user_id: user.id).or(Publication.of_user_followings(user)).or(Publication.of_user_events(user)).distinct
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