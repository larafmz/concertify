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

  ## CALLBACKS

   after_create_commit :create_notification, if: -> { relation_type == 0 && followed_type == "User" }
   after_destroy_commit :remove_notification, if: -> { relation_type == 0 && followed_type == "User" }

  ## CALLBACK METHODS

  private

    def create_notification
      notification = InteractionNotificationNotifier.with(
        follower: follower, 
        record: self,
        message: notification_message,
        path: Rails.application.routes.url_helpers.user_path(follower_id))
      notification.deliver(User.find(followed_id))
    end

    def remove_notification
      Notification.for_user(followed_id).for_record(self).destroy_all
    end

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

  ## ISTANCE METHODS

  public
            
    def notification_message
      user_str = "<strong> #{follower.username} </strong>"
      {
          key: "new_follower",
          user: user_str,
      }
    end

end