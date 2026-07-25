class Publication < Interactuable

    ## RELATIONSHIPS
    
    belongs_to :artist, optional: true
    belongs_to :event, optional: true
    
    ## VALIDATIONS
    
    validates :review, presence: true

    ## CLASS METHODS

    def self.viewables(user)
      if user.present?
        #Remove Publications from users than have BLOCKED ME
        Publication.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
      else
        Publication.all
      end
    end

    ## INSTANCE METHODS


end