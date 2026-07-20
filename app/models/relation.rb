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

    validate :cant_follow_blocked_user
    validate :cant_follow_self

  ## SCOPES

  ## VALIDATION METHODS

    def cant_follow_blocked_user
        if follower.blocked_user?(followed)
            errors.add(:follower, I18n.t("messages.cant_follow_blocked_user"))
        end
    end

    def cant_follow_self
        if follower.id == followed.id
            errors.add(:follower, I18n.t("messages.cant_follow_self"))
        end
    end

end