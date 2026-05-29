module ApplicationHelper

    def formatted_concert_date(date, start_time)
      str = date.strftime("%A")
      start_time = Time.parse(start_time) if start_time
      str += " • #{start_time.strftime("%I:%M %p")}" if start_time
      str
    end

    def best_quality_image(images)
      return nil if images.nil? || images.empty?
      images.find { |img| img["width"] > 1000 } || images.find { |img| img["width"] > 500 } || images.first
    end
end
