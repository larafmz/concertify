require "application_system_test_case"

class ArtistTest < ApplicationSystemTestCase
    fixtures :all

    test "PI13 - show_artist" do
        TicketmasterService.stub :artist_by_id, {"name"=>"Miley Cyrus", "id"=> "1", "classifications" => [{"genre" => {"name" =>  "Rock"}}]} do
            TicketmasterService.stub :events_by, [] do
                visit "/artists/ticketmaster?ticketmaster_id=1"
                assert_current_path "/artists/ticketmaster?ticketmaster_id=1", wait: 20
                assert_text "#ARTIST"
                assert_text "Miley Cyrus"
                assert_text "Rock"
            end
        end
    end

    test "PI23 - search_artists_without_filters" do
        response_api = [
            {"name"=>"Miley Cyrus", "id"=> "3"}, 
            {"name"=>"Dua Lipa", "id"=> "4"}, 
        ]
        TicketmasterService.stub :artists_by, response_api do
            TicketmasterService.stub :events_by, [] do
                visit "/" 
                find(".dropdown button", text: "View").click
                click_on "Artists"
                assert_text "Leiva", wait: 10
                assert_text "Rihanna"
                assert_text "Miley Cyrus"
                assert_text "Dua Lipa"
                assert_text "Kesha"
                assert_selector ".item-artist", count: 5
            end
        end 
    end

    test "PI24 - search_artists_by_name" do
        TicketmasterService.stub :artists_by, [] do
            TicketmasterService.stub :events_by, [] do
                visit "/" 
                find(".dropdown button", text: "View").click
                click_on "Artists"
                fill_in "artist-filter-search", with: "ihan"
                click_on "Filter"
                assert_text "Rihanna", wait: 10
                assert_selector ".item-artist", count: 1
            end
        end 
    end

    test "PI25 - search_artists_by_genre" do
        TicketmasterService.stub :artists_by, [] do
            TicketmasterService.stub :events_by, [] do
                visit "/" 
                find(".dropdown button", text: "View").click
                click_on "Artists"
                select "Pop", from: "genre_id"
                click_on "Filter"
                assert_text "Rihanna", wait: 10
                assert_selector ".item-artist", count: 1
            end
        end 
    end

end