class Comment < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :text, presence: true

    ## CALLBACKS

        after_create_commit :create_notification, if: -> { user_id != interactuable.user.id }
        after_destroy :remove_notification

    ## CALLBACK METHODS

    private

        def create_notification
            notification = InteractionNotificationNotifier.with(
                follower: user, 
                record: self, 
                path: Rails.application.routes.url_helpers.comments_interactuable_path(interactuable.id))
            notification.deliver(interactuable.user)
        end

        def remove_notification
            Notification.for_user(interactuable.user_id).for_record(self).destroy_all
        end

    public

        def notification_message(noti)
            I18n.t("notifications.new_comment", model: interactuable.class.singular.downcase, comment: text)
        end

end