class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :event_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }
  kindable :company, { :undefined => 0, :alone => 1, :accompanied => 2}

  MAX_FROM_LENGTH = 50

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :event

  ## SCOPES

    scope :upcoming, -> { joins(:event).where(events: { date: Date.today...8.days.from_now.to_date }) }

  ## VALIDATIONS

    validates :event_seat_details, :from, length: { maximum: MAX_FROM_LENGTH }, allow_nil: true
    validates :event_id, uniqueness: { scope: :user_id, message: I18n.t('messages.event_already_registered') }
  
  ## CALLBACKS

    before_validation :truncate_data
    after_destroy_commit :exit_chat

  ## CALLBACKS METHODS

  private

    def truncate_data
      self.event_seat_details = event_seat_details.truncate(MAX_FROM_LENGTH) unless event_seat_details.blank?
      self.from = from.truncate(MAX_FROM_LENGTH) unless from.blank?
    end

    def exit_chat
      event.chat.exit_chat(user_id) if event&.chat
    end

  ## CLASS METHODS

  public

    def self.viewables(user)
      if user.present?
        #Remove FA's from users than have BLOCKED ME
        fa = FutureAssistance.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
        #Remove FA's from users than I HAVE BLOCKED
        fa.where.not(user_id: Relation.where(follower_id: user.id, relation_type: 1).select(:followed_id))
      else
        FutureAssistance.all
      end
    end
  
  ## INSTANCE METHODS

  def event_seat_string
    return get_event_seat_name if event_seat
    nil
  end 
  
  def company_string
    case company
    when 1
      "👤 #{get_company_name}"
    when 2
      "👥 #{get_company_name}"
    else
      nil
    end
  end

  def notification_message
    days_left = self.event.days_left(actual: Date.today)
    event_str = "<span style='font-weight: bold' > #{self.event.complete_name} </span>"
    {
        key: "upcoming_event_#{days_left}",
        event: event_str
    }
  end


end