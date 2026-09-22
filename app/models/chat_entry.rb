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
    validates :text, length: { maximum: 1000 }
    validate :cant_talk_to_blocked_users, if: -> { !chat.group_chat? } 

  ## CALLBACKS

    after_create_commit :broadcast_change
   
  ## VALIDATIONS METHODS

    def cant_talk_to_blocked_users
      other_user = chat.other_user(user)
      if other_user.blocked_user?(user.id) || user.blocked_user?(other_user.id)
        errors.add(:chat, "you can't chat with blocked user")
      end
    end

  ## CALLBACKS METHODS

  private

    def broadcast_change
      # update chat to unread
      ChatUser.where(chat_id: chat.id).where.not(user_id: user.id).each do |chat_user|
        chat_user.mark_as_unread
      end

      # update chat and sidebar of user who sent the message
      BroadcastHelper.add_message_to_chat(self, user)
      BroadcastHelper.remove_chat_from_sidebar(self.chat, user)
      BroadcastHelper.append_chat_to_sidebar(self.chat, user)

      # job to update the view of the rest of the users of the chat
      ChatEntryBroadcastJob.perform_later(self.id, user.id)
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