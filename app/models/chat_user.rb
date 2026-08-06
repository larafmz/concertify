class ChatUser < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## SCOPE
  
    scope :unread, -> { where(read_at: nil) }

  ## VALIDATIONS

    validates :user_id, uniqueness: { scope: :chat_id }

  ## VALIDATIONS

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