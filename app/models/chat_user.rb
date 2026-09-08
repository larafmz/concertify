class ChatUser < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## SCOPE
  
    scope :unread, -> { where(read_at: nil) }

  ## VALIDATIONS

    validates :user_id, uniqueness: { scope: :chat_id }
    validate :user_logged_event, if: -> { chat&.event } 

  ## CALLBACKS

   after_update_commit :broadcast_change, if: -> { saved_change_to_read_at? && read_at_before_last_save.nil? && read_at.present? }

  ## VALIDATIONS METHODS

  def user_logged_event
    register = Register.find_by(user_id: user_id, event_id: chat.event_id)
    future_assistance = FutureAssistance.find_by(user_id: user_id, event_id: chat.event_id)
    unless register.present? || future_assistance.present?
      errors.add(:user_id, "User must assist or have assisted to the event to join the chat.")
    end
  end

  ## CALLBACKS METHODS

  private

    def broadcast_change
      # replace chat in sidebar to show its read
      Turbo::StreamsChannel.broadcast_replace_to(
        [user, "sidebar"],
         target: "chat_#{chat.id}",
        partial: "chats/sidebar_chat",
        locals: { chat: chat, current_user: user }
      )
    
      # update header
      broadcast_replace_to( # se reemplaza todo el trozo del header 
        # hace actualizacion a a todos los usuarios
        [ user, "messages_header" ], # = turbo_stream_from current_user, "messages_header"
        target: "messages_header", # {id: "messages_header" ... }
        partial: "layouts/shared/messages_bubble",
        locals: { current_user: user }
      )

    end

  ## INSTANCE METHODS

  public

    def mark_as_read
      self.update(read_at: Time.current)
    end

    def mark_as_unread
      self.update(read_at: nil)
    end

    def read?
      read_at.present?
    end

end