class DeliveryMethods::NotificationCounter < ApplicationDeliveryMethod

  def deliver
    BroadcastHelper.update_notifications_header(self.notification.recipient)
  end

end
