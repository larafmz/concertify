module RequestHelper

    def color_request(status)
      case status
      when 1
        "rgb(252, 170, 46)"
      when 2
        "rgb(245, 83, 83)"
      else
        "rgb(88, 216, 94);"
      end
    end

    def second_color_request(status)
      case status
        when 1
          "rgb(78, 61, 41)"
        when 2
          "rgb(78, 41, 41);"
        else
          "rgb(48, 66, 49)"
        end
    end

    def message_request(status)
      return I18n.t("request_message.0") if status.nil?
      I18n.t("request_message.#{status}")
    end

    def emoji_request(status)
      case status
      when 1
        "⌛︎"
      when 2
        "X"
      else
        "✓"
      end
    end

end