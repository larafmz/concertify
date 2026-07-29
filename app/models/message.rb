class Message < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :chat

  ## VALIDATIONS

    validates :text, presence: true


end