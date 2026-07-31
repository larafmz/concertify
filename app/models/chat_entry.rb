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
  
    after_create_commit -> {
      chat.users.each do |user|
        broadcast_append_to(
          [chat, user],
          target: "chat_entries",
          partial: "chat_entries/show",
          locals: {
            chat_entry: self,
            current_user: user
          }
        )
      end
    }

    after_create_commit do
      Rails.logger.info "BROADCAST #{id}"
    end

  ## INSTANCE METHODS

  def show_date_separator?
    previous = previous_chat
    previous.nil? || previous.created_at.to_date != created_at.to_date
  end

  def same_previous_user?
    previous = previous_chat
    previous.nil? || previous.user_id == user_id
  end

private 
  
  def previous_chat
    previous = chat.chat_entries.where("created_at < ?", created_at).order(created_at: :desc).first
  end

end