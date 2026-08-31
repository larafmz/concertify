class Like < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :user_id, uniqueness: { scope: :interactuable_id }
        validate :cant_like_own

    ## SCOPES

        scope :for_event, ->(event_id) { joins(:interactuable).where(interactuables: { event_id: event_id }).where(interactuables: { type: "Register" }) }
        scope :for_interactuable_user, -> (user_id) { joins(:interactuable).where(interactuables: { user_id: user_id }) }
        scope :for_user, -> (user_id) { where(user_id: user_id)}

    ## CALLBACKS

        after_create_commit :create_notification
        after_destroy_commit :remove_notification

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
            Notification.for_user(interactuable.user_id).for_record(self).destroy_all if interactuable.user_id
        end

    ## VALIDATION METHODS

        def cant_like_own
            if user.id == interactuable.user.id
                errors.add(:base, t("messages.cant_like_own"))
            end
        end

    ## INSTANCE METHODS

    public
        
        def notification_message
            user_str = "<strong> #{user.username} </strong>"
            {
                key: "new_like",
                user: user_str,
                model: interactuable.class.singular.downcase,
            }
        end
 
end