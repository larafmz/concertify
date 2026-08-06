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

   after_create_commit :mark_as_unread
   after_create_commit :broadcast_message

  ## CALLBACKS METHODS

  private

    def mark_as_unread
      ChatUser.where(chat_id: chat.id).where.not(user_id: user.id).each do |chat_user|
        chat_user.mark_as_unread
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