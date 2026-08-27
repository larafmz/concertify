class Publication < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :artist, optional: true
    belongs_to :event, optional: true
    
    ## VALIDATIONS
    
    validates :review, presence: true

    ## SCOPES

    scope :by_artist, ->(artist_id) { left_joins(:artist).where(artist: { id: artist_id }) }

    ## CLASS METHODS

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

    ## INSTANCE METHODS


end