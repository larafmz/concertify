include TicketmasterEventHelper

class Request < ApplicationRecord

  ##CONFIGURATIONS

  kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## RELATIONSHIPS
    belongs_to :requester, class_name: "User", optional: true
    has_one :event
    accepts_nested_attributes_for :event, allow_destroy: false
    has_one :artist #TO/DO
    accepts_nested_attributes_for :artist, allow_destroy: false

  ## SCOPES

    scope :accepted, -> { where(status: 0).or(where(status: nil)) }
    scope :pending, -> { where(status: 1) }

  ## VALIDATIONS

  ## CALLBACKS

      after_update :create_notification, if: :saved_change_to_status?
      after_create :create_notification_for_admins
      after_destroy :remove_notification

  ## CALLBACK METHODS

  private

      def create_notification
        remove_notification #remove old notis ab this request
        notification = InteractionNotificationNotifier.with(
          record: self, 
          path: Rails.application.routes.url_helpers.requests_user_path(requester.id),
          message: "#{I18n.t("notifications.event_update")} <span style='color: #{color_request(status: self.status)}'>#{get_status_name.upcase}</span>"
        )
        notification.deliver(requester)
      end

      def create_notification_for_admins
        notification = InteractionNotificationNotifier.with(
            record: self,
            path: Rails.application.routes.url_helpers.requests_path,
            message:  I18n.t("notifications.new_event", tour_name: self.event.complete_name, artist: self.event.artists&.first&.name)        
          )
        notification.deliver(User.admins)
      end

      def remove_notification
        Notification.for_record(self).destroy_all
      end

  ## CLASS METHODS

  public

    def status_string
      status ? get_status_name : ""
    end

    def pending?
      status == 1
    end

    def accepted?
      status == 0 || status == nil
    end

    def color_request(status: self.status)
      case status
        when 1
          "rgb(252, 170, 46)"
        when 2
          "rgb(245, 83, 83)"
        else
          "rgb(88, 216, 94);"
        end
    end

    def second_color_request
      case status
        when 1
          "rgb(78, 61, 41)"
        when 2
          "rgb(78, 41, 41);"
        else
          "rgb(48, 66, 49)"
        end
    end

    def message_request
      return I18n.t("request_message.0") if status.nil?
      I18n.t("request_message.#{status}")
    end

    def emoji_request
      case status
      when 1
        "⌛︎"
      when 2
        "X"
      else
        "✓"
      end
    end

end