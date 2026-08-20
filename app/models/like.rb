class Like < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :user_id, uniqueness: { scope: :interactuable_id }
        validate :cant_like_own

    ## CALLBACKS

        after_create_commit :create_notification
        after_destroy_commit :remove_notification

    ## CALLBACK METHODS

    private

        def create_notification
            notification = InteractionNotificationNotifier.with(
                message: I18n.t("notifications.new_like", 
                user: user.username, 
                model: interactuable.class.singular.downcase), 
                follower: user, 
                record: self, 
                path: Rails.application.routes.url_helpers.comments_interactuable_path(interactuable.id))
            notification.deliver(User.find(interactuable.user_id))
        end

        def remove_notification
            Notification.for_record(interactuable.user_id, self).destroy_all
        end

    ## VALIDATION METHODS

        def cant_like_own
            if user.id == interactuable.user.id
                errors.add(:photos, t("messages.cant_like_own"))
            end
        end
 
end