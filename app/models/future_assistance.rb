class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :event_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }
  kindable :company, { :undefined => 0, :alone => 1, :accompanied => 2}

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :event

  ## SCOPES

    scope :upcoming, -> { joins(:event).where(events: { date: Date.today...8.days.from_now.to_date }) }

  ## VALIDATIONS

    validates :event_seat_details, :from, length: { maximum: 20 }, allow_nil: true
  
  ## CALLBACKS

    before_validation :truncate_data

    def truncate_data
      self.event_seat_details = event_seat_details.truncate(20) if !event_seat_details.blank?
      self.from = from.truncate(20) if !from.blank?
    end

  ## CLASS METHODS

    def self.viewables(user)
      if user.present?
        #Remove FA's from users than have BLOCKED ME
        FutureAssistance.where.not(user_id: Relation.where(followed_id: user.id, relation_type: 1).select(:follower_id))
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

  def notification_message(noti)
    days_left = (noti.created_at.to_date - self.event.date).to_i.abs
    I18n.t("notifications.upcoming_event_#{days_left}", time: days_left, event: self.event.tour_name)
  end


end