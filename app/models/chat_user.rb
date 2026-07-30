class ChatUser < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## VALIDATIONS

    validates :user_id, uniqueness: { scope: :chat_id }

end