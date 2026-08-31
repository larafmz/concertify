class Request < ApplicationRecord

  ##CONFIGURATIONS

    include TicketmasterEventHelper

    kindable :status, { :accepted => 0, :pending => 1, :denied => 2 }

  ## RELATIONSHIPS
    belongs_to :requester, class_name: "User"
    has_one :event, dependent: :destroy
    accepts_nested_attributes_for :event, allow_destroy: false

  ## SCOPES

    scope :accepted, -> { where(status: 0) }
    scope :pending, -> { where(status: 1) }
    scope :denied, -> { where(status: 2) }
    scope :by_status, -> (status) { where(status: status) }

  ## VALIDATIONS

    validates :status, presence: true

  ## CALLBACKS

      after_create :create_notification_for_admins
      after_update :create_notification, if: :saved_change_to_status?
      after_update :change_to_accepted, if: :saved_change_to_status?
      after_destroy_commit :remove_notification

  ## CALLBACK METHODS

  private

      def create_notification_for_admins
        notification = InteractionNotificationNotifier.with(
            record: self,
            path: Rails.application.routes.url_helpers.requests_path,
            message: notification_message_new_request
          )
        notification.deliver(User.admins)
      end

      def create_notification
        remove_notification #remove old notis ab this request
        notification = InteractionNotificationNotifier.with(
          record: self, 
          path: Rails.application.routes.url_helpers.requests_user_path(requester.id),
          message: notification_message_update_request
        )
        notification.deliver(requester)
      end

      def change_to_accepted
        event.artists.first&.update(status: 0) if status == 0
      end

      def remove_notification
        Notification.for_record(self).destroy_all
      end

  ## CLASS METHODS

    def self.do_search(params={}, order_by="created_at DESC", user: nil)
        params ||= {}
        requests = Request.order(order_by)
        requests = requests.where(requester_id: user.id) if user.present?
        requests = requests.by_status(params[:status].to_i) if params[:status]
        requests
    end

  ## INSTANCE METHODS

  public

    def artist
      self.event&.artists&.first
    end

    def matching_events
      return nil unless self.event.artists.first.present?
      self.artist.events.accepted.by_date(self.event.date).by_country_code(self.event.ubication.country.code)
    end

    def status_string
      status ? get_status_name : ""
    end

    def pending?
      status == 1
    end

    def accepted?
      status == 0 
    end

    def get_event_id
      return event.id if accepted?
      return existing_event_id if status == 2 && existing_event_id.present?
    end

    def notification_message_new_request
      {
          key: "new_event",
          tour_name: event.complete_name,
          artist: artist&.name,
      }
    end

    def notification_message_update_request
      status_str = "<span style='color: #{color_request(self.status)}'>#{get_status_name.upcase}</span>"
      {
          key: "event_update",
          event: event.tour_name,
          status: status_str,
      }
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
      return message if message.present?
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