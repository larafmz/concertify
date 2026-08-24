class Repost < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :user_id, uniqueness: { scope: :interactuable_id }
        validate :cant_repost_own

    ## VALIDATION METHODS

        def cant_repost_own
            if user.id == interactuable.user.id
                errors.add(:photos, t("messages.cant_repost_own"))
            end
        end


    ## CALLBACKS

        after_create_commit :create_notification
        after_destroy :remove_notification

    ## CALLBACK METHODS

    private

        def create_notification
            notification = InteractionNotificationNotifier.with(
                follower: user, 
                record: self,
                message: notification_message,
                path: Rails.application.routes.url_helpers.comments_interactuable_path(interactuable.id))
            notification.deliver(interactuable.user)
        end

        def remove_notification
            Notification.for_user(interactuable.user_id).for_record(self).destroy_all
        end   
        
    ## INSTANCE METHODS

    public
                    
        def notification_message
            str = "<strong> #{user.username} </strong>"
            str + I18n.t("notifications.new_repost", model: interactuable.class.singular.downcase)
        end

end