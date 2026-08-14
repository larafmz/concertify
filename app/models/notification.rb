class Notification < Noticed::Notification
  
    ## RELATIONSHIPS

        belongs_to :user
        belongs_to :sender, class_name: "User"
        belongs_to :notificable, polymorphic: true

    ## VALIDATIONS

        validates :recipient_id, uniqueness: { scope: :chat_id }

    ## SCOPES

        scope :for_record, ->(user_id, record) { where(recipient_type: "User", recipient_id: user_id)
            .joins(:event).where(noticed_events: { record_type: record.class.name, record_id: record.id } )
        }

    ## CALLBACKS

        after_create_commit :broadcast_notification

    ## CALLBACKS METHODS

        def broadcast_notification
            # TO/DO
        end

    ## CLASS METHODS

    private

        def self.plural
            self.model_name.human(count: 2)
        end

        def self.han(attribute)
            self.human_attribute_name(attribute)
        end

end