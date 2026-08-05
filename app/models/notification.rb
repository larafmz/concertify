class Notification < Noticed::Notification
    
  scope :messages, -> { where(type: NewMessageNotifier::Notification.sti_name) }
  
end