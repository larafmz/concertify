class ApplicationNotifier < Noticed::Event

    deliver_by :notification_counter, class: "DeliveryMethods::NotificationCounter"

end
