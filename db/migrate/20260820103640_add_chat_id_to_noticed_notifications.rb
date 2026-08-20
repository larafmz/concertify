class AddChatIdToNoticedNotifications < ActiveRecord::Migration[7.2]
  def change
    add_reference :noticed_notifications, :chat
  end
end
