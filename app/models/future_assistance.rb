class FutureAssistance < ApplicationRecord

  ##CONFIGURATIONS

  kindable :concert_seat, { :pista => 0, :grada => 1, :vip => 2, :otro => 3 }

  ## RELATIONSHIPS

    belongs_to :user
    belongs_to :concert
    belongs_to :interactuable, optional: true


  ## VALIDATIONS

    validates :concert_seat_details, :from, length: { maximum: 20 }, allow_nil: true
  
  ## CALLBACKS

    before_validation :truncate_data

    def truncate_data
      self.concert_seat_details = concert_seat_details.truncate(20) if !concert_seat_details.blank?
      self.from = from.truncate(20) if !from.blank?
    end
  
  ## INSTANCE METHODS
  
  def full_ubication
    if from && !from.empty?
      if alone
        return "✈︎ Asiste sin acompañantes desde #{from}." 
      else
        return "✈︎ Desde #{from}." 
      end
    end
    return "Asiste sin acompañantes." if alone
    nil
  end

  def full_concert_seat
    str = ""
    str += "#{get_concert_seat_name} " if concert_seat
    str += "#{concert_seat_details}" if concert_seat_details
    return nil if str.empty?
    return "Ubicado en "+ str
  end


end