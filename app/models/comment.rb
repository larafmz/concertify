class Comment < ApplicationRecord

    ## RELATIONSHIPS
    
        belongs_to :user
        belongs_to :interactuable

        belongs_to :comment_father, class_name: "Comment", optional: true
        has_many :replies, class_name: "Comment", foreign_key: :comment_father_id, dependent: :destroy

    ## VALIDATIONS

        validates :text, presence: true
        validates :text, length: { maximum: 500 }
        validate :cant_comment_blocked
        validate :cant_reply_blocked

    ## CALLBACKS

        after_create_commit :create_notification
        after_destroy_commit :remove_notification

    ## VALIDATIONS METHODS

        def cant_comment_blocked
            if user.blocked_user?(interactuable.user.id) || interactuable.user.blocked_user?(user.id)
                errors.add(:base, "cant like blocked")
            end
        end

        def cant_reply_blocked
            if comment_father
                if user.blocked_user?(comment_father.user.id) || comment_father.user.blocked_user?(user.id) 
                    errors.add(:base, "cant like blocked")
                end
            end
        end

    ## CALLBACK METHODS

    private

        def create_notification
            notification = ApplicationNotifier.with(
                follower: user, 
                record: self, 
                message: notification_message,
                path: Rails.application.routes.url_helpers.comment_path(self.id)
            )
            notification.deliver(all_users)
        end

        def remove_notification
            Notification.for_user(interactuable.user_id).for_record(self).destroy_all if interactuable.user_id
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

        def reply(user_id, text)
            Comment.create(interactuable_id: self.interactuable_id, user_id: user_id, text: text, comment_father_id: self.id)
        end

        def notification_message
            user_str = "<strong> #{user.username} </strong>"
            key = comment_father ? "#{interactuable.type.downcase}.new_reply" : "#{interactuable.type.downcase}.new_comment"
            text = comment_father ? comment_father.text : interactuable.review
            {
                key: key,
                user: user_str,
                stars: interactuable.try(:get_rating),
                tour_name: "<strong> #{interactuable.event&.tour_name} </strong>",
                text: "<span style='font-style:italic; overflow-wrap:anywhere;'> #{text} </span>",
                comment: "<br> <span style='overflow-wrap:anywhere'> | #{self.text} </span>",
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