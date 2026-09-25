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

   after_update_commit :broadcast_change, if: -> { saved_change_to_read_at? }

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
      if read_at_before_last_save.nil? && read_at.present? || read_at_before_last_save.present? && read_at.nil?
        BroadcastHelper.update_messages_header(user)
        BroadcastHelper.replace_chat_in_sidebar(chat, user)
      end
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