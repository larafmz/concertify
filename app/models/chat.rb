class Chat < ApplicationRecord

  ## RELATIONSHIPS

    has_many :chat_users, dependent: :destroy
    has_many :users, through: :chat_users
    
    has_many :chat_entries, dependent: :destroy
    belongs_to :event, optional: true

  ## SCOPES

    scope :by_users, ->(user1_id, user2_id) { 
      where(event_id: nil).joins(:chat_users).where(chat_users: { user_id: [user1_id, user2_id] }).group(:id).having("COUNT(DISTINCT chat_users.user_id) = 2")
    }

    scope :order_by_recent_messages, -> { left_joins(:chat_entries).where(chat_entries: { chat_type: 0}).group(:id).order(Arel.sql("MAX(chat_entries.created_at) DESC")) }

  ## CLASS METHODS

    def self.create_private_chat(user1_id, user2_id)
      chat = Chat.new
      chat.chat_users << ChatUser.new(user_id: user1_id) 
      chat.chat_users << ChatUser.new(user_id: user2_id) 
      chat
    end

    def self.create_event_chat(event_id, user_id)
      chat = Chat.find_or_create_by(event_id: event_id)
      unless chat.chat_users.exists?(user_id: user_id)
        chat.chat_users << ChatUser.new(user_id: user_id) 
        ChatEntry.create(chat_id: chat.id, user_id: user_id, text: "entered_chat", chat_type: 1)
      end
      chat
    end

  ## INSTANCE METHODS

    def group_chat?
      event.present?
    end

    def messages
      chat_entries.user_messages 
    end

    def other_user(current_user)
      users.find { |u| u.id != current_user.id }
    end

    def name(current_user)
      return event.tour_name if event
      username = other_user(current_user)&.username
      username.present? ? username : "NOT FOUND"
    end

    def photo(current_user)
      return event.photo if event
      other_user(current_user)&.icon
    end

    def has_notification?(current_user)
      !chat_users.find { |cu| cu.user_id == current_user.id }.read?
    end

    def exit_chat(user_id)
      self.chat_users.find_by(user_id: user_id)&.destroy
      ChatEntry.create(chat_id: self.id, user_id: user_id, text: "exited_chat", chat_type: 1)
    end

end