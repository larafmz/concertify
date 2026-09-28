class Chat < ApplicationRecord

  ## RELATIONSHIPS

    belongs_to :event, optional: true

    has_many :chat_users, dependent: :destroy
    has_many :users, through: :chat_users
    has_many :chat_entries, dependent: :destroy

  ## VALIDATIONS

    validates :event_id, uniqueness: { allow_nil: true }

  ## SCOPES

    scope :by_users, ->(user1_id, user2_id) { 
      where(event_id: nil).joins(:chat_users).where(chat_users: { user_id: [user1_id, user2_id] }).group(:id).having("COUNT(DISTINCT chat_users.user_id) = 2")
    }

    scope :order_by_recent_messages, -> { left_joins(:chat_entries).where(chat_entries: { chat_type: 0 }).group(:id).order(Arel.sql("MAX(chat_entries.created_at) DESC, chats.id DESC")) }

  ## CLASS METHODS

    def self.create_private_chat(user1_id, user2_id)
      chat = Chat.new
      chat.chat_users << ChatUser.new(user_id: user1_id) 
      chat.chat_users << ChatUser.new(user_id: user2_id) 
      chat.save
      chat
    end

    def self.create_event_chat(event_id, user_id)
      chat = Chat.find_or_create_by(event_id: event_id)
      unless chat.chat_users.exists?(user_id: user_id)
        chat.chat_users << ChatUser.new(user_id: user_id) 
        ChatEntry.create(chat_id: chat.id, user_id: user_id, text: "entered_chat", chat_type: 1)
      end
      chat.save
      chat
    end

  ## INSTANCE METHODS

    def send_message(user_id, message)
      ChatEntry.create(chat_id: self.id, chat_type: 0, user_id: user_id, text: message)
    end

    def group_chat?
      event.present?
    end

    def other_user(user)
      users.find { |u| u.id != user.id }
    end

    def name(user)
      return event.tour_name if event
      username = other_user(user)&.username
      username.present? ? username : "NOT FOUND"
    end

    def photo(user)
      return event.photo if event
      other_user(user)&.icon
    end

    def has_notification?(user)
      !chat_users.find { |cu| cu.user_id == user.id }&.read?
    end

    def exit_chat(user_id)
      if self.chat_users.find_by(user_id: user_id)&.destroy
        ChatEntry.create(chat_id: self.id, user_id: user_id, text: "exited_chat", chat_type: 1)
      end
    end

end