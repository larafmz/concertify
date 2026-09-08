module BroadcastHelper

    def self.add_message_to_chat(chat_entry, user)
        chat = chat_entry.chat
        Turbo::StreamsChannel.broadcast_append_to( # se añade un mensaje
            # hace actualizaciona a los usuarios que esten en el chat, "chat_entries" es solo un label
            [ chat, user, "chat_entries" ], # = turbo_stream_from [@chat, current_user] "chat_entries" if @chat
            target: "chat_entries", # {id: "chat_entries" ... }
            partial: "chat_entries/index_item",
            locals: { chat_entry: chat_entry, current_user: user }
        )
    end

    def self.remove_chat_from_sidebar(chat, user)
        Turbo::StreamsChannel.broadcast_remove_to(
            [user, :sidebar],
            target: "chat_#{chat.id}"
        )
    end

    def self.append_chat_to_sidebar(chat, user)
        Turbo::StreamsChannel.broadcast_prepend_to(
            [user, "sidebar"],
            target: "chats_list",
            partial: "chats/sidebar_chat",
            locals: { chat: chat, current_user: user }
        )
    end

    def self.replace_chat_in_sidebar(chat, user)
        Turbo::StreamsChannel.broadcast_replace_to(
            [user, "sidebar"],
            target: "chat_#{chat.id}",
            partial: "chats/sidebar_chat",
            locals: { chat: chat, current_user: user }
        )
    end

    def self.update_messages_header(user)
        Turbo::StreamsChannel.broadcast_replace_to( # se reemplaza todo el messages_header del header
            # hace actualizacion a a todos los usuarios
            [ user, "messages_header" ], # = turbo_stream_from current_user, "messages_header"
            target: "messages_header", # {id: "messages_header" ... }
            partial: "layouts/shared/messages_bubble",
            locals: { current_user: user }
        )
    end

    def self.update_notifications_header(user)
        Turbo::StreamsChannel.broadcast_replace_to( # se reemplaza todo el notifications_header del header
            # hace actualizacion a a todos los usuarios
            [ user, "notifications_header" ], # = turbo_stream_from current_user, "notifications_header"
            target: "notifications_header", # {id: "notifications_header" ... }
            partial: "layouts/shared/notifications_bubble",
            locals: { current_user: user }
        )
    end

end