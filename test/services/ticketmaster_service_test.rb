require "test_helper"

class TicketmasterServiceTest < ActiveSupport::TestCase
  test "merge_events combines database and API events" do
    db_event = Event.new( date: Date.new(2026, 9, 10), start_time: "20:00" )

    api_event = {
      "dates" => {
        "start" => {
          "localDate" => "2026-09-11",
          "localTime" => "21:00"
        }
      }
    }

    result = TicketmasterService.merge_events([db_event], [api_event])

    assert_equal 2, result.length
    assert_equal :db, result[0][:source]
    assert_equal :api, result[1][:source]
  end
end