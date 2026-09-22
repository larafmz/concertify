class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :event_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }
  kindable :company, { :alone => 1, :accompanied => 2}

  MAX_FROM_LENGTH = 50

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :event

  ## SCOPES

    scope :upcoming, -> { joins(:event).where(events: { date: Date.today...8.days.from_now.to_date }) }
    scope :by_event, -> (event_id) { where(event_id: event_id) }
    scope :by_event_seat, -> (event_seat) { where(event_seat: event_seat)}
    scope :by_company, -> (company) { where(company: company)}
    scope :by_from, -> (from) { where(from: from)}

  ## VALIDATIONS

    validates :event_seat_details, :from, length: { maximum: MAX_FROM_LENGTH }, allow_nil: true
    validates :event_id, uniqueness: { scope: :user_id, message: I18n.t('messages.event_already_registered') }
  
  ## CALLBACKS

    after_destroy_commit :exit_chat

  ## CALLBACKS METHODS

  private

    def exit_chat
      event.chat.exit_chat(user_id) if event&.chat
    end

  ## CLASS METHODS

  public

    def self.search_by(current_user, params: {}, event_id: nil)
      future_assistances = FutureAssistance.viewables(current_user)
      future_assistances = future_assistances.by_event(event_id) if event_id.present?

      future_assistances = future_assistances.by_event_seat(params[:event_seat]) if params[:event_seat].present?
      future_assistances = future_assistances.by_company(params[:company]) if params[:company].present?
      future_assistances = future_assistances.by_from(params[:from]) if params[:from].present?

      future_assistances

    end

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