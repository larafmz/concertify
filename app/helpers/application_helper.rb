module ApplicationHelper

    def formatted_concert_date(date, start_time)
      str = date.strftime("%A")
      start_time = Time.parse(start_time) if start_time
      str += " • #{start_time.strftime("%I:%M %p")}" if start_time
      str
    end
end
