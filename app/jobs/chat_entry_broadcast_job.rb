class ChatEntryBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_entry_id, sender_id)
    chat_entry = ChatEntry.find(chat_entry_id)
    chat = chat_entry.chat
    chat.users.where.not(id: sender_id).find_each do |user|
      BroadcastService.add_message_to_chat(chat_entry, user)
      BroadcastService.remove_chat_from_sidebar(chat, user)
      BroadcastService.append_chat_to_sidebar(chat, user)
      BroadcastService.update_messages_header(user)
    end 
  end

end