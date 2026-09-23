require "application_system_test_case"

class EventTest < ApplicationSystemTestCase
    fixtures :all

    test "PI13 - show_artist" do
        TicketmasterService.stub :artist_by_id, {"name"=>"Miley Cyrus", "id"=> "1", "classifications" => [{"genre" => {"name" =>  "Rock"}}]} do
            visit "/artists/ticketmaster?ticketmaster_id=1"
            assert_current_path "/artists/ticketmaster?ticketmaster_id=1", wait: 20
            assert_text "#ARTIST"
            assert_text "Miley Cyrus"
            assert_text "Rock"
        end
    end
    
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


end