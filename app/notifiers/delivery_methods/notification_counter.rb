class DeliveryMethods::NotificationCounter < ApplicationDeliveryMethod

  def deliver
    BroadcastService.update_notifications_header(self.notification.recipient)
  end

end
