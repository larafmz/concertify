require "application_system_test_case"

class EventTest < ApplicationSystemTestCase
  fixtures :all

  test "PI14 - show_event" do
      response = 
          {   
              "name"=>"Rihanna TOUR", "id"=> "1", 
              "dates" => { "start" => { "localDate" => "2026-09-17" } }, 
              "_embedded" => { 
                  "attractions" => [{"id": "5" }], 
                  "venues" => [ { 
                      "name" => "Estadio", 
                      "city" => { "name" => "Oviedo" },
                      "state" => { "name" => "Invent" }, 
                      "country" => {"name" => "Spain", "countryCode" => "ES" }
                  }]
              }
          }
      TicketmasterService.stub :event_by_id, response do
          visit "/events/ticketmaster?ticketmaster_id=1"
          assert_current_path "/events/ticketmaster?ticketmaster_id=1", wait: 20
          assert_text "#EVENT"
          assert_text "Rihanna TOUR"
          event = Event.find_by(ticketmaster_id: 1)
          assert_text "Thursday 17 Sep 2026"
          assert_text "Oviedo"
          assert_text "Invent"
          assert_text "Spain"
      end
  end

  test "PI15 - search_events_without_filters" do
      response_api = [
          {"name"=>"Miley Cyrus TOUR", "id"=> "1", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
          {"name"=>"Dua Lipa TOUR", "id"=> "3", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
          {"name"=>"Michael Jackson TOUR", "id"=> "4", "dates" => { "start" => { "localDate" => "2026-09-17" } }}, 
      ]
      TicketmasterService.stub :events_by, response_api do
          visit "/" 
          find(".dropdown button", text: "View").click
          click_on "Events"
          assert_text "Miley Cyrus TOUR", wait: 10
          assert_text "Dua Lipa TOUR"
          assert_text "Michael Jackson TOUR"
          assert_text "Evento 9"
          assert_text "Búsqueda"
          assert_text "Evento 6"
          assert_selector ".item-event", count: 6
          assert_text "6 results"
      end 
  end

  test "PI16 - Search_events_by_name" do
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "search_filter_id", with: "Búsqueda"
      click_on "Filter"
      assert_text "Búsqueda", wait: 10
      assert_selector ".item-event", count: 1
      assert_text "1 results"
    end
  end

  test "PI17 - Search_events_by_first_date" do
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "first_date", with: Date.today
      click_on "Filter"
      assert_text "Evento 9", wait: 10
      assert_text "Evento antiguo2"
      assert_text "Búsqueda"
      assert_text "Evento 6"
      assert_selector ".item-event", count: 4
      assert_text "4 results"
    end
  end

  test "PI18 - Search_events_by_second_date" do
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "second_date", with: Date.today+1
      click_on "Filter"
      assert_text "Evento antiguo1", wait: 10
      assert_text "Evento 9"
      assert_text "Evento antiguo2"
      assert_text "Búsqueda"
      assert_selector ".item-event", count: 4
      assert_text "4 results"
    end
  end

  test "PI19 - Search_events_by_two_dates" do
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "first_date", with: Date.today
      fill_in "second_date", with: Date.today+1
      click_on "Filter"
      assert_text "Evento 9", wait: 10
      assert_text "Evento antiguo2"
      assert_text "Búsqueda"
      assert_selector ".item-event", count: 3
      assert_text "3 results"
    end
  end

  test "PI20 - Search_events_by_invalid_dates" do
    TicketmasterService.stub :events_by, [] do
    visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "first_date", with: Date.today
      fill_in "second_date", with: Date.today-1
      click_on "Filter"
      assert_text "0 results", wait: 10
      assert_selector ".item-event", count: 0
    end
  end

  test "PI21 - Search_events_by_country" do
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      select "Spain", from: "country_id"
      click_on "Filter"
      assert_text "Evento antiguo2", wait: 10
      assert_selector ".item-event", count: 1
      assert_text "1 results"
    end
  end

  test "PI22 - Search_events_by_filters" do
    #returns "Búsqueda" because the artist of "Búsqueda" is called "Artista ANTIGUO1"
    TicketmasterService.stub :events_by, [] do
      visit "/" 
      assert_selector ".dropdown button"
      find(".dropdown button", text: "View").click
      click_on "Events"
      fill_in "search_filter_id", with: "antiguo"
      fill_in "first_date", with: Date.today-1
      fill_in "second_date", with: Date.today+1.year
      select "Spain", from: "country_id"
      click_on "Filter"
      assert_text "Búsqueda", wait: 10
      assert_text "1 results"
      assert_selector ".item-event", count: 1
    end
  end

end