class DeliveryMethods::NotificationCounter < ApplicationDeliveryMethod

  def deliver
    notification = self.notification
    recipient = notification.recipient

    #TO/DO
   
  end

end
