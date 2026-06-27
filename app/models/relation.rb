class Relation < ApplicationRecord

  ## RELATIONSHIPS
    
    belongs_to :follower, class_name: "User", optional: true
    belongs_to :followed, polymorphic: true

    ## SCOPES

    scope :artists, -> { where(followed_type: "Artist" ) }
    scope :users, -> { where(followed_type: "User" ) }

  ##CONFIGURATIONS

    kindable :relation_type, { :follow => 0, :block => 1}

  ## VALIDATIONS

end