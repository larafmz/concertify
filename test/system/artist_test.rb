require "application_system_test_case"

class ArtistTest < ApplicationSystemTestCase
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

end