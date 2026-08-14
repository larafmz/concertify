class Comment < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

    ## VALIDATIONS

        validates :text, presence: true

    ## CALLBACKS

        after_create_commit :create_notification
        after_destroy :remove_notification

    ## CALLBACK METHODS

    private

        def create_notification
            notification = InteractionNotificationNotifier.with(message: I18n.t("notifications.new_comment", user: user.username, model: interactuable.class.singular, comment: text), follower: interactuable.user, record: self)
            notification.deliver(User.find(interactuable.user_id))
        end

        def remove_notification
            Notification.for_record(interactuable.user_id, self).destroy_all
        end

end