class Notification < Noticed::Notification
  
    ## RELATIONSHIPS

        belongs_to :chat, optional: true

    ## VALIDATIONS

        validates :recipient_id, uniqueness: { scope: :chat_id }, if: :chat_id?

    ## SCOPES

        scope :for_record, ->(user_id, record) { where(recipient_type: "User", recipient_id: user_id)
            .joins(:event).where(noticed_events: { record_type: record.class.name, record_id: record.id } )
        }

        scope :read, -> { where.not(read_at: nil) }
        scope :unread, -> { where(read_at: nil) }

    ## CALLBACKS

        after_create :broadcast_notification

    ## CALLBACKS METHODS

        def broadcast_notification
            puts "ENTRA EN AFTER CREATE"
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