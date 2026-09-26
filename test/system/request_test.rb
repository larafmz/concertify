require "application_system_test_case"
include ActiveJob::TestHelper

class RequestTest < ApplicationSystemTestCase
    fixtures :all

    def setup_user2
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "prueba2@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "Log in"
            assert_current_path "/", wait: 15
        end
    end

    def setup_user3
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "prueba3@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "Log in"
            assert_current_path "/", wait: 15
        end
    end

    test "PI75 - create_request_for_existing_artist" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            artist = artists(:artist6)
            user = users(:prueba2)
            visit "/events"
            click_on "add_event_id"
            assert "artist_name_id", wait: 10
            assert "tour_name_id"
            assert "date_id"
            assert "start_time_id"
            assert "venue_id"
            assert "city_id"
            assert "country_id"
            fill_in "artist_name_id", with: "Leiva"
            fill_in "tour_name_id", with: "Gigante Tour"
            fill_in "date_id", with: Date.today-1.year
            fill_in "start_time_id", with: Time.current
            fill_in "venue_id", with: "La Eria"
            fill_in "city_id", with: "Oviedo"
            within("#modal") do
                select "Spain", from: "country_id"
            end
            click_on "Save"
            assert_current_path "/users/#{users(:prueba2).id}/requests", wait: 10
            assert_selector ".request_item", count: 1
            request = Request.last
            assert_selector "#tour_name_#{request.id}", text: "Gigante Tour"
            assert_text "La Eria, Oviedo, Spain"
            assert_text I18n.l(Date.today-1.year, format: "%-d %b %Y")
            assert_text "We are verifying the details"
            assert_text "⌛︎ Pending"
            assert_text "Sent by @#{user.username}"
            assert_selector "#link_artist_#{artist.id}", count: 1
            click_on "link_artist_#{artist.id}"
            assert_current_path "/artists/#{artist.id}", wait: 10
        end
    end

    test "PI76 - create_request_for_existing_artist_in_api" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            TicketmasterService.stub :artist_by_name, {"name"=>"Bad Bunny", "id"=> "6"}  do
                TicketmasterService.stub :artist_by_id, {"name"=>"Bad Bunny", "id"=> "6"} do
                    user = users(:prueba2)
                    visit "/events"
                    click_on "add_event_id"
                    fill_in "artist_name_id", with: "Bad Bunny", wait: 10
                    fill_in "tour_name_id", with: "Debí tirar más fotos"
                    fill_in "date_id", with: Date.today+1.year
                    fill_in "venue_id", with: "Riyadh Air Metropolitano"
                    fill_in "city_id", with: "Madrid"
                    within("#modal") do
                        select "Spain", from: "country_id"
                    end
                    click_on "Save"
                    assert_current_path "/users/#{users(:prueba2).id}/requests", wait: 10
                    assert_selector ".request_item", count: 1
                    request = Request.last
                    assert_selector "#tour_name_#{request.id}", text: "Debí tirar más fotos"
                    assert_text "Riyadh Air Metropolitano, Madrid, Spain"
                    assert_text I18n.l(Date.today+1.year, format: "%-d %b %Y")
                    assert_text "We are verifying the details"
                    assert_text "⌛︎ Pending"
                    assert_text "Sent by @#{user.username}"
                    artist = Artist.last
                    assert_equal artist.name, "Bad Bunny"
                    assert_selector "#link_artist_#{artist.id}", count: 1
                    click_on "link_artist_#{artist.id}"
                    assert_current_path "/artists/#{artist.id}", wait: 10
                end
            end
        end
    end

    test "PI77 - create_request_for_unexisting_artist" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            TicketmasterService.stub :artist_by_name, {}  do
                user = users(:prueba2)
                visit "/events"
                click_on "add_event_id"
                fill_in "artist_name_id", with: "Artista inventado", wait: 10
                fill_in "tour_name_id", with: "Tour inventado"
                fill_in "date_id", with: Date.today+1.month
                within("#modal") do
                    select "Italy", from: "country_id"
                end
                click_on "Save"
                assert_current_path "/users/#{users(:prueba2).id}/requests", wait: 10
                assert_selector ".request_item", count: 1
                request = Request.last
                assert_selector "#tour_name_#{request.id}", text: "Tour inventado"
                assert_text "Italy"
                assert_text I18n.l(Date.today+1.month, format: "%-d %b")
                assert_text "We are verifying the details"
                assert_text "⌛︎ Pending"
                assert_text "Sent by @#{user.username}"
                artist = Artist.find_by(name: "Artista inventado")
                assert_no_selector "#link_artist_#{artist.id}"
                assert_selector "#artist_name_#{artist.id}", count: 1
            end
        end
    end

    test "PI78 - create_request_for_empty_artist" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            TicketmasterService.stub :artist_by_name, {}  do
                visit "/events"
                click_on "add_event_id"
                click_on "Save"
                assert_text "Artist is invalid"
            end
        end
    end

    test "PI79 - create_request_for_empty_date" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            TicketmasterService.stub :artist_by_name, {}  do
                visit "/events"
                click_on "add_event_id"
                click_on "Save"
                assert_text "Date can't be blank"
            end
        end
    end

    test "PI80 - create_request_for_empty_date" do
        setup_user2
        TicketmasterService.stub :events_by, [] do
            TicketmasterService.stub :artist_by_name, {}  do
                visit "/events"
                click_on "add_event_id"
                click_on "Save"
                assert_text "Country must exist"
            end
        end
    end

    test "PI81 - request_changes_status" do
        setup_user3
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        request = requests(:request3)
        event = request.event
        perform_enqueued_jobs do
            request.update(status: 0)
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:prueba3).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "Your request for #{event.tour_name} has been updated to status: #{request.status_string.upcase}"
    end

    test "PI82 - edit_request" do
        setup_user3
        TicketmasterService.stub :artist_by_name, {}  do
            find(".dropdown button", text: "Profile").click
            click_on "My Requests"
            user = users(:prueba3)
            request = requests(:request3)
            click_on "edit_request_#{request.id}" 
            fill_in "artist_name_id", with: "Nuevo artista", wait: 10
            fill_in "tour_name_id", with: "Nuevo nombre de tour"
            fill_in "date_id", with: Date.today-1.month
            within("#modal") do
                select "Italy", from: "country_id"
            end
            click_on "Save"
            within("#request-#{request.id}") do
                assert_selector "#tour_name_#{request.id}", text: "Nuevo nombre de tour"
                assert_text "Nuevo artista"
                assert_text "Italy"
                assert_text I18n.l(Date.today-1.month, format: "%-d %b")
                assert_text "We are verifying the details"
                assert_text "⌛︎ Pending"
                assert_text "Sent by @#{user.username}"
            end
        end
    end

    test "PI83 - edit_denied_request" do
        setup_user3
        find(".dropdown button", text: "Profile").click
        click_on "My Requests"
        user = users(:prueba3)
        request = requests(:request4)
        assert_no_selector "#edit_request_#{request.id}" 
        assert_no_selector "#destroy_request_#{request.id}" 
        within("#request-#{request.id}") do
            assert_text "We were unable to verify the information."
            assert_text "Denied"
        end
    end

    test "PI84 - edit_accepted_request" do
        setup_user3
        find(".dropdown button", text: "Profile").click
        click_on "My Requests"
        user = users(:prueba3)
        request = requests(:request1)
        assert_no_selector "#edit_request_#{request.id}" 
        assert_no_selector "#destroy_request_#{request.id}" 
        within("#request-#{request.id}") do
            assert_text "Information verified and added to the application."
            assert_text "Accepted"
        end
        assert_selector "#view_event_#{request.id}" 
        click_on "view_event_#{request.id}" 
        assert_current_path "/events/#{request.event.id}", wait: 10
    end

    test "PI85 - remove_request" do
        setup_user3
        find(".dropdown button", text: "Profile").click
        click_on "My Requests"
        user = users(:prueba3)
        request = requests(:request3)
        assert_selector "#request-#{request.id}"
        assert_selector "#destroy_request_#{request.id}" 
        accept_confirm do
            click_on "destroy_request_#{request.id}" 
        end
        assert_no_selector "#request-#{request.id}", wait: 10
    end

end