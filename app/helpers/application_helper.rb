module ApplicationHelper

    def formatted_event_date(date, start_time)
      str = I18n.t("date.day_names")[date.wday]
      str += " #{short_date_with_year(date)}"
      str += " • #{formatted_time(start_time)}" if start_time
      str
    end

    def wday_time(date, start_time)
      str = I18n.t("date.day_names")[date.wday]
      str += " • #{formatted_time(start_time)}" if start_time
      str
    end

    def short_date(date)
      date.year == Date.current.year ? I18n.l(date, format: "%-d %b") : I18n.l(date, format: "%-d %b %Y")
    end

    def formatted_time(time)
      if I18n.locale == :es
        time.strftime("%H:%M")
      else
        time.strftime("%I:%M %p")
      end
  end

    def short_date_with_year(date)
      I18n.l(date, format: "%-d %b %Y")
    end

    def best_quality_image(images)
      return nil if images.nil? || images.empty?
      images.find { |img| img["width"] > 1000 } || images.find { |img| img["width"] > 500 } || images.first
    end

  def time_status(event_date, event_time = nil)
    today = Date.today
    return "past" if event_date < today
    return "future" if event_date > today
    event_time.nil? || event_time > Time.current ? "future" : "past"
  end

  def custom_time_ago_in_words(time)
    time <= Date.today-1.day ? short_date(time) :  t("ago", time:  time_ago_in_words(time))
  end

  def short_time_ago(time)
    seconds = Time.current - time

    case seconds
    when 0...60
      "#{seconds.to_i}s"
    when 60...3600
      "#{(seconds / 60).to_i}min"
    when 3600...86400
      "#{(seconds / 3600).to_i}h"
    when 86400...2_592_000
      "#{(seconds / 86400).to_i}d"
    when 2_592_000...31_536_000
      "#{(seconds / 2_592_000).to_i}mo"
    else
      "#{(seconds / 31_536_000).to_i}y"
    end
  end
  
end
