require "application_system_test_case"

class FutureAssistanceTest < ApplicationSystemTestCase
    fixtures :all

    setup do
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "prueba2@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "Log in"
            assert_current_path "/", wait: 15
        end
    end

    test "PI34 - Create_future_assistance" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event5)
            click_on "will_assist_to_#{event.id}"
            assert "from_id", wait: 10
            from = Faker::Lorem.characters(number: 50)
            fill_in "from_id", with: from
            assert "event_seat_details_id"
            event_seat_details = Faker::Lorem.characters(number: 50)
            fill_in "event_seat_details_id", with: event_seat_details
            select "Standing", from: "event_seat_id"
            select "Alone", from: "company_id"
            click_on "Save"
            click_on "my_future_assistance_#{event.id}", wait: 10
            register = Register.last
            assert_current_path "/users/#{users(:prueba2).id}/future_assistances"
            assert_text "Búsqueda"
            assert_text "Alone"
            assert_text "Standing"
            assert_text event_seat_details
            assert_text from
            assert_selector ".future_assistance_item", count: 3
        end
    end

    test "PI35 - Create_register_to_anterior_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event3)
            assert_no_selector "will_assist_to_#{event.id}"
        end
    end

    test "PI36 - Create_register_to_same_date_anterior_time_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event9)
            assert_no_selector "will_assist_to_#{event.id}"
        end
    end

    test "PI37 - Create_register_to_same_date_posterior_time_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event4)
            click_on "will_assist_to_#{event.id}"
            assert "from_id", wait: 10
            from = Faker::Lorem.characters(number: 50)
            fill_in "from_id", with: from
            assert "event_seat_details_id"
            event_seat_details = Faker::Lorem.characters(number: 50)
            fill_in "event_seat_details_id", with: event_seat_details
            select "Standing", from: "event_seat_id"
            select "Alone", from: "company_id"
            click_on "Save"
            click_on "my_future_assistance_#{event.id}", wait: 10
            register = Register.last
            assert_current_path "/users/#{users(:prueba2).id}/future_assistances"
            assert_text "Evento antiguo2"
            assert_text "Alone"
            assert_text "Standing"
            assert_text event_seat_details
            assert_text from
            assert_selector ".future_assistance_item", count: 3
        end
    end

    test "PI38 - Edit_future_assistance" do
        find(".dropdown button", text: "Profile").click
        click_on "My Future Assistances"
        user = users(:prueba2)
        future_assistance = user.future_assistances.last
        click_on "edit_future_assistance_#{future_assistance.id}"
        assert "from_id", wait: 10
        from = Faker::Lorem.characters(number: 50)
        fill_in "from_id", with: from
        assert "event_seat_details_id"
        event_seat_details = Faker::Lorem.characters(number: 50)
        fill_in "event_seat_details_id", with: event_seat_details
        select "Seating", from: "event_seat_id"
        select "Accompanied", from: "company_id"
        click_on "Save"
        assert_text "Evento 6", wait: 10
        assert_text "Accompanied"
        assert_text "Seating"
        assert_text event_seat_details
        assert_text from
        assert_selector ".future_assistance_item", count: 2
    end

    test "PI39 - Destroy_future_assistance" do
        find(".dropdown button", text: "Profile").click
        click_on "My Future Assistances"
        user = users(:prueba2)
        future_assistance_id = user.future_assistances.last.id
        accept_confirm do
            click_on "destroy_future_assistance_#{future_assistance_id}"
        end
        assert_current_path "/users/#{user.id}/future_assistances"
        assert_no_selector "future-assistance-#{future_assistance_id}"
    end

end