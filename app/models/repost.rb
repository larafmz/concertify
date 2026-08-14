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
            notification = InteractionNotificationNotifier.with(message: I18n.t("notifications.new_repost", user: user.username, model: interactuable.class.singular), follower: interactuable.user, record: self)
            notification.deliver(User.find(interactuable.user_id))
        end

        def remove_notification
            Notification.for_record(interactuable.user_id, self).destroy_all
        end        

end