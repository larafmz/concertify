class ChatEntryBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_entry, sender_id)
    chat = chat_entry.chat
    chat.users.where.not(id: sender_id).find_each do |user|
      BroadcastHelper.add_message_to_chat(chat_entry, user)
      BroadcastHelper.remove_chat_from_sidebar(chat, user)
      BroadcastHelper.append_chat_to_sidebar(chat, user)
    end 
  end

end