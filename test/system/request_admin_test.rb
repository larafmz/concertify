require "application_system_test_case"
include ActiveJob::TestHelper

class RequestAdminTest < ApplicationSystemTestCase
    fixtures :all

    setup do
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "admin@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "login_button"
            assert_current_path "/", wait: 15
        end
    end

    test "PI86 - change_request_status_to_accepted" do
        find(".dropdown button", text: "View").click
        click_on "Requested Events"
        request = requests(:request3)
        assert_selector "#request-#{request.id}"
        click_on "edit_request_#{request.id}" 
        fill_in "artist_name_id", with: "Leiva", wait: 10
        select "Accepted", from: "status_id"
        click_on "Save"
        within("#request-#{request.id}") do
            assert_text "Information verified and added to the application.", wait: 10
            assert_text "Accepted"
        end
        assert_selector "#view_event_#{request.id}" 
        click_on "view_event_#{request.id}" 
        assert_current_path "/events/#{request.event.id}", wait: 10
    end

    test "PI87 - change_request_status_to_denied" do
        find(".dropdown button", text: "View").click
        click_on "Requested Events"
        request = requests(:request3)
        assert_selector "#request-#{request.id}"
        click_on "edit_request_#{request.id}" 
        fill_in "artist_name_id", with: "Leiva", wait: 10
        fill_in "message_id", with: "No hemos podido comprobar la información proporcionada.", wait: 10
        select "Denied", from: "status_id"
        click_on "Save"
        within("#request-#{request.id}") do
            assert_text "No hemos podido comprobar la información proporcionada.", wait: 10
            assert_no_text "We were unable to verify the information.", wait: 10
            assert_text "Denied"
        end
        assert_no_selector "#view_event_#{request.id}" 
    end

    test "PI88 - event_exists_and_denied" do
        request = requests(:request1)
        event = request.event
        same_event = Event.create!(tour_name: "Cualquiera", artists: [artists(:artist4)], date: event.date, ubication: event.ubication, ticketmaster_id: "cualquiera" )
        find(".dropdown button", text: "View").click
        click_on "Requested Events"
        assert_selector "#request-#{request.id}", wait: 10
        click_on "edit_request_#{request.id}" 
        select "Denied", from: "status_id", wait: 10
        find("#existing_event_id").all("option")[1].select_option #select first option
        click_on "Save"
        within("#request-#{request.id}", visible: :all) do
            assert_text "The event already exists in the system.", wait: 10
            assert_text "Denied"
        end
        request.reload
        assert_selector "#view_event_#{request.id}" 
        click_on "view_event_#{request.id}"
        assert_current_path "/events/#{request.existing_event_id}", wait: 10
    end

    test "PI89 - event_exists_but_accepted" do
        request = requests(:request1)
        event = request.event
        same_event = Event.create!(tour_name: "Cualquiera", artists: [artists(:artist4)], date: event.date, ubication: event.ubication, ticketmaster_id: "cualquiera" )
        find(".dropdown button", text: "View").click
        click_on "Requested Events"
        assert_selector "#request-#{request.id}", wait: 10
        click_on "edit_request_#{request.id}" 
        select "Accepted", from: "status_id"
        find("#existing_event_id").all("option")[1].select_option #select first option
        click_on "Save"
        assert_text "Event must be denied when an existing event is selected.", wait: 10
    end

    test "PI90 - event_exists_but_pending" do
        request = requests(:request1)
        event = request.event
        same_event = Event.create!(tour_name: "Cualquiera", artists: [artists(:artist4)], date: event.date, ubication: event.ubication, ticketmaster_id: "cualquiera" )
        find(".dropdown button", text: "View").click
        click_on "Requested Events"
        assert_selector "#request-#{request.id}", wait: 10
        click_on "edit_request_#{request.id}" 
        select "Pending", from: "status_id"
        find("#existing_event_id").all("option")[1].select_option #select first option
        click_on "Save"
        assert_text "Event must be denied when an existing event is selected.", wait: 10
    end

    test "PI91 - new_request_notification" do
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        event = Event.new(tour_name: "Cualquiera", artists: [artists(:artist4)], date: Date.today, ubication: ubications(:ubication1))
        perform_enqueued_jobs do
            Request.create!(event: event, requester: users(:prueba2), status: 1)
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:admin).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "A user has requested the addition of a new event: #{event.tour_name} by #{artists(:artist4).name}"
    end

end