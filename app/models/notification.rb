class Notification < Noticed::Notification
  
    ## RELATIONSHIPS

        belongs_to :chat, optional: true

    ## VALIDATIONS

        validates :recipient_id, uniqueness: { scope: :chat_id }, if: :chat_id?

    ## SCOPES

        scope :for_user, ->(user_id) { where(recipient_type: "User", recipient_id: user_id) }
        scope :for_record, ->(record) { joins(:event).where(noticed_events: { record_type: record.class.name, record_id: record.id } )  }

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

    ## ISTANCE METHODS

    public

        def user
            self.params[:follower]
        end

        def full_message
            self.record.notification_message(self)
        end

        def icon
            if self.record.respond_to?(:interactuable) && self.record.interactuable.photo&.attached?
                self.record.interactuable.photo
            end
        end

        def path
            self.params[:path]
        end

        def for_follow?
            self.record.class.name == Relation.name
        end
end