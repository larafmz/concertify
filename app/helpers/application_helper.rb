module ApplicationHelper

    def formatted_concert_date(date, start_time)
      str = date.strftime("%A")
      str += " • #{start_time.strftime("%I:%M %p")}" if start_time
      str
    end

    def short_date(date)
      date.strftime("%e %b %Y")
    end

    def best_quality_image(images)
      return nil if images.nil? || images.empty?
      images.find { |img| img["width"] > 1000 } || images.find { |img| img["width"] > 500 } || images.first
    end

  def time_status(concert_date, concert_time = nil)
    today = Date.today
    return "past" if concert_date < today
    return "future" if concert_date > today
    concert_time.nil? || concert_time > Time.current ? "future" : "past"
  end
  
end
