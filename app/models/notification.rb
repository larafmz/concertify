class Notification < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user

  ## SCOPES

    scope :for_chats, -> { where(notificable_type: "Chat" ) }
    scope :not_opened, -> { where(opened: false ) }
  
  ## CLASS METHODS

  def self.create_for_chat(user_creator_id, chat_id)
    chat = Chat.find(chat_id)
    chat.users.each do |user|
      if user.id != user_creator_id
        n = Notification.find_or_initialize_by(user_id: user.id, notificable_type: "Chat", notificable_id: chat.id)
        n.opened = false
        n.save!
      end
    end
  end

  ## INSTANCE METHODS



   

end