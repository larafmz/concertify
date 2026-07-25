class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :concert_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }
  kindable :company, { :undefined => 0, :alone => 1, :accompanied => 2}

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :concert

  ## VALIDATIONS

    validates :concert_seat_details, :from, length: { maximum: 20 }, allow_nil: true
  
  ## CALLBACKS

    before_validation :truncate_data

    def truncate_data
      self.concert_seat_details = concert_seat_details.truncate(20) if !concert_seat_details.blank?
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

  def concert_seat_string
    return get_concert_seat_name if concert_seat
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


end