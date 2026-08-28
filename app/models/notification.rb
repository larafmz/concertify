class Notification < Noticed::Notification
  
    ## RELATIONSHIPS

        belongs_to :chat, optional: true
        belongs_to :recipient, polymorphic: true

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

        def self.create_for_upcoming_future_assistance(future_assistance)
            notification = InteractionNotificationNotifier.with(
                record: future_assistance, 
                message: future_assistance.notification_message, 
                path: Rails.application.routes.url_helpers.future_assistances_user_path(future_assistance.user))
            notification.deliver(future_assistance.user)
        end

    ## ISTANCE METHODS

    public

        def user
            self.params[:follower]
        end

        def message
            data = params[:message]
            I18n.t("notifications.#{data[:key]}", **data.except(:key).symbolize_keys )
        end

        def icon
            if self.record.respond_to?(:interactuable) && self.record.interactuable.photo&.attached?
                self.record.interactuable.photo
            elsif self.record.respond_to?(:event) && self.record.event.photo&.attached?
                self.record.event.photo
            end
        end

        def path
            self.params[:path]
        end

        def for_follow?
            self.record.class.name == Relation.name
        end
end