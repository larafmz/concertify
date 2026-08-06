class ChatEntry < ApplicationRecord

    kindable :chat_type, { :user_message => 0, :info_message => 1 }

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## SCOPES

    scope :user_messages, -> { where(chat_type: 0) }
    scope :info_messages, -> { where(chat_type: 1) }    

  ## VALIDATIONS

    validates :text, presence: true

  ## CALLBACKS

   after_create_commit :create_notification
   after_create_commit :broadcast_message

  ## CALLBACKS METHODS

  private

    def create_notification
      NewMessageNotifier.with(sender: user, record: chat).deliver(chat.users.where.not(id: user.id))

      chat.users.each do |current_user|
        broadcast_replace_to( # se reemplaza todo el sidebar
            # hace actualizaciona a todos los usuarios, aunque no esten en el mismo que esten en el chat
            [ current_user, "sidebar" ], # = turbo_stream_from current_user, "sidebar" if @chat
            target: "chat_sidebar", # {id: "chat_sidebar" ... }
            partial: "chats/sidebar",
            locals: { chats: current_user.chats, current_user: current_user, open_chat_id: current_user.open_chat_id }
          )
      end
    end

    def broadcast_message   
      chat.users.each do |current_user|
        broadcast_append_to( # se añade un mensaje
          # hace actualizaciona a los usuarios que esten en el chat, "messages" es solo un label
          [ chat, current_user, "messages" ], # = turbo_stream_from [@chat, current_user] "messages" if @chat
          target: "messages", # {id: "messages" ... }
          partial: "chat_entries/chat_entry",
          locals: { chat_entry: self, current_user: current_user }
        )
      end
    end

  ## INSTANCE METHODS

  public

    def show_date_separator?
      previous = previous_chat
      previous.nil? || previous.created_at.to_date != created_at.to_date
    end

    def same_previous_user?
      previous = previous_chat
      previous.nil? || previous.user_id == user_id
    end

    def same_previous_type?
      previous = previous_chat
      previous.nil? || previous.chat_type == chat_type
    end

  private 
  
    def previous_chat
      previous = chat.chat_entries.where("created_at < ?", created_at).order(created_at: :desc).first
    end

end