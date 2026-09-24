require "test_helper"

class EventTest < ActiveSupport::TestCase
  fixtures :all

  test "PU08 - Create_event" do
    TicketmasterService.stub :event_by_id, {"name"=>"Miley Cyrus TOUR", "id"=> "1", "dates" => { "start" => { "localDate" => "2026-09-17" } } } do
      event1 = Event.create_or_update_by_ticketmaster_id("1")
      assert event1.persisted?
      assert_equal "Miley Cyrus TOUR", event1.tour_name
    end
  end
    
  test "PU09 - Create_event_invalid_ticketmaster_id" do
    TicketmasterService.stub :event_by_id, nil do
      event2 = Event.create_or_update_by_ticketmaster_id("2")
      assert_nil event2
    end
  end

  test "PU10 - Create_existent_event" do
    TicketmasterService.stub :event_by_id, {"name"=>"Dua Lipa TOUR", "id"=> "3", "dates" => { "start" => { "localDate" => "2026-09-17" } }} do
      event3 = events(:event3)
      Event.create_or_update_by_ticketmaster_id(event3.ticketmaster_id)
      event3.reload
      assert_not_equal "Evento antiguo1", event3.tour_name
      assert_equal "Dua Lipa TOUR", event3.tour_name
    end
  end
  
  test "PU11 - Create_existent_updated_event" do
    TicketmasterService.stub :event_by_id, {"name"=>"Michael Jackson TOUR", "id"=> "4", "dates" => { "start" => { "localDate" => "2026-09-17" } }} do
      event4 = events(:event4)
      Event.create_or_update_by_ticketmaster_id(event4.ticketmaster_id)
      event4.reload
      assert_not_equal "Michael Jackson TOUR", event4.tour_name
      assert_equal "Evento antiguo2", event4.tour_name
    end
  end

  test "PU12 - Search_events_without_filters" do
    response_api = [
      {"name"=>"Miley Cyrus TOUR", "id"=> "1", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
      {"name"=>"Dua Lipa TOUR", "id"=> "3", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
      {"name"=>"Michael Jackson TOUR", "id"=> "4", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
    ]
    TicketmasterService.stub :events_by, response_api do
      events = Event.search_by
      assert_equal 6, events.length
      assert_equal events[0][:event]["name"], "Miley Cyrus TOUR"
      assert_equal events[1][:event]["name"], "Dua Lipa TOUR"
      assert_equal events[2][:event]["name"], "Michael Jackson TOUR"
      assert_equal events[3][:event].tour_name, "Evento 9"
      assert_equal events[4][:event].tour_name, "Búsqueda"
      assert_equal events[5][:event].tour_name, "Evento 6"
    end
  end

  test "PU13 - Search_events_by_name" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {search: "Búsqueda"})
      assert_equal 1, events.length
      assert_equal events[0][:event].tour_name, "Búsqueda"
    end
  end

  test "PU14 - Search_events_by_first_date" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {first_date: Date.today})
      assert_equal 4, events.length
      assert_equal events[0][:event].tour_name, "Evento 9"
      assert_equal events[1][:event].tour_name, "Evento antiguo2"
      assert_equal events[2][:event].tour_name, "Búsqueda"
      assert_equal events[3][:event].tour_name, "Evento 6"
    end
  end

  test "PU15 - Search_events_by_second_date" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {second_date: Date.today+1})
      assert_equal 4, events.length
      assert_equal events[0][:event].tour_name, "Evento antiguo1"
      assert_equal events[1][:event].tour_name, "Evento 9"
      assert_equal events[2][:event].tour_name, "Evento antiguo2"
      assert_equal events[3][:event].tour_name, "Búsqueda"
    end
  end

  test "PU16 - Search_events_by_two_dates" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {first_date: Date.today, second_date: Date.today+1})
      assert_equal 3, events.length
      assert_equal events[0][:event].tour_name, "Evento 9"
      assert_equal events[1][:event].tour_name, "Evento antiguo2"
      assert_equal events[2][:event].tour_name, "Búsqueda"
    end
  end

  test "PU17 - Search_events_by_invalid_dates" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {first_date: Date.today, second_date: Date.today-1})
      assert_equal 0, events.length
    end
  end

  test "PU18 - Search_events_by_artist" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(artist: artists(:artist3))
      assert_equal 2, events.length
      assert_equal events[0][:event].tour_name, "Evento antiguo1"
      assert_equal events[1][:event].tour_name, "Búsqueda"
    end
  end

  test "PU19 - Search_events_by_country" do
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {country: countries(:spain).code})
      assert_equal 1, events.length
      assert_equal events[0][:event].tour_name, "Evento antiguo2"
    end
  end

  test "PU20 - Search_events_by_filters" do
    #returns "Búsqueda" because the artist of "Búsqueda" is called "Artista ANTIGUO1"
    TicketmasterService.stub :events_by, [] do
      events = Event.search_by(params: {search: "antiguo1", first_date: Date.today-1, second_date: Date.today+1.year, country: countries(:italy).code}, artist: artists(:artist3))
      assert_equal 1, events.length
      assert_equal events[0][:event].tour_name, "Búsqueda"
    end
  end
  

end
