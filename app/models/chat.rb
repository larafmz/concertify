class Chat < ApplicationRecord

  ## RELATIONSHIPS

    has_many :chat_users, dependent: :destroy
    accepts_nested_attributes_for :chat_users
    
    has_many :messages, dependent: :destroy
    belongs_to :event, optional: true

  ## SCOPES

    scope :by_users, ->(user1_id, user2_id) { 
      where(event_id: nil).joins(:chat_users).where(chat_users: { user_id: [user1_id, user2_id] }).group(:id).having("COUNT(DISTINCT chat_users.user_id) = 2")
    }

  ## INSTANCE METHODS

    def other_user(current_user)
      chat_users.where.not(user_id: current_user.id).first.user
    end

    def name(current_user)
      event.tour_name if event
      other_user(current_user).username
    end

    def photo(current_user)
      event.photo if event
      other_user(current_user).icon
    end

end