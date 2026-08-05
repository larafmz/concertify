module NotificationExtensions
  extend ActiveSupport::Concern

  included do

    belongs_to :organization

    scope :messages, -> { where(type: NewMessageNotifier::Notification.sti_name) }
    scope :for_record, ->(record) { joins(:event).where( noticed_events: { record_type: record.class.name, record_id: record.id } ) }

  end

  # You can also add instance methods here
end

Rails.application.config.to_prepare do
  # You can extend Noticed::Event or Noticed::Notification here
  Noticed::Notification.include NotificationExtensions

end