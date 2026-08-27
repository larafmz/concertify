class Comment < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

        belongs_to :comment_father, class_name: "Comment", optional: true
        has_many :replies, class_name: "Comment", foreign_key: :comment_father_id, dependent: :destroy

    ## VALIDATIONS

        validates :text, presence: true

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
                path: Rails.application.routes.url_helpers.comment_path(self.id))
            notification.deliver(all_users)
        end

        def remove_notification
            Notification.for_user(interactuable.user_id).for_record(self).destroy_all
        end

    public

        def notification_message
            str = "<strong> #{user.username} </strong>"
            return str + I18n.t("notifications.new_reply", model: interactuable.class.singular.downcase, comment: text) if comment_father
            str + I18n.t("notifications.new_comment", model: interactuable.class.singular.downcase, comment: text)
        end

        # def father_link
        #     return Rails.application.routes.url_helpers.comment_path(comment_father.id) if comment_father
        #     return Rails.application.routes.url_helpers.comments_interactuable_path(interactuable.id)
        # end

        def all_users
            users = [ interactuable.user ]
            comment = self
            while comment
                users << comment.user if comment.user
                comment = comment.comment_father
            end
            users.uniq.excluding(self.user)
        end

end