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
        after_destroy_commit :remove_notification

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

      ## CLASS METHODS

        def self.viewables(user)
            if user.present?
                comms = Comment.where.not( user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id) )
                comms.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id) )
            else
                Comment.all
            end
        end

      ## INSTANCE METHODS

        def notification_message
            user_str = "<strong> #{user.username} </strong>"
            key = comment_father ? "new_reply" : "new_comment"
            {
                key: key,
                user: user_str,
                model: interactuable.class.singular.downcase,
                comment: text,
            }
        end

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