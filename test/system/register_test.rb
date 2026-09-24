require "application_system_test_case"

class RegisterTest < ApplicationSystemTestCase
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

    test "PI28 - Create_register" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event3)
            click_on "assisted_to_#{event.id}"
            assert "review_id", wait: 50
            fill_in "review_id", with: Faker::Lorem.characters(number: 500), wait: 50
            find("#rating5").click
            assert_checked_field "rating5"
            files = Array.new(10) { Rails.root.join("test/fixtures/files/profile.jpeg") }
            attach_file "photos_id", files
            click_on "Save"
            click_on "my_register_#{event.id}", wait: 10
            register = Register.last
            assert_current_path "/interactuables/#{register.id}"
            assert_text "Evento antiguo1"
            assert_text "★★★★★"
            assert_selector ".register-photo", count: 10
        end
    end

    test "PI29 - Create_register_to_posterior_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event5)
            assert_no_selector  "assisted_to_#{event.id}"
        end
    end

    test "PI30 - Create_register_to_same_date_posterior_time_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event4)
            assert_no_selector  "assisted_to_#{event.id}"
        end
    end

    test "PI31 - Create_register_to_same_date_anterior_time_event" do
        TicketmasterService.stub :events_by, [] do
            visit "/events"
            event = events(:event10)
            click_on "assisted_to_#{event.id}"
            assert "review_id", wait: 50
            fill_in "review_id", with: Faker::Lorem.characters(number: 500), wait: 50
            find("#rating3").click
            assert_checked_field "rating3"
            files = Array.new(10) { Rails.root.join("test/fixtures/files/profile.jpeg") }
            attach_file "photos_id", files
            click_on "Save"
            click_on "my_register_#{event.id}", wait: 10
            register = Register.last
            assert_current_path "/interactuables/#{register.id}"
            assert_text "Evento 10"
            assert_text "★★★"
            assert_selector ".register-photo", count: 10
        end
    end

    test "PI32 - Edit_register" do
        find(".dropdown button", text: "Profile").click
        click_on "My Registers"
        user = users(:prueba2)
        register = user.registers.first
        click_on "interactuable_#{register.id}"
        find(".dropdown button", text: "Edit").click
        click_on "Edit Register"
        assert_selector "#review_id", wait: 10
        review = Faker::Lorem.characters(number: 500)
        fill_in "review_id", with: review
        assert_field "review_id", with: review
        choose "rating2"
        assert_checked_field "rating2"
        click_on "Save"
        assert_text review, wait: 10
        assert_text "★★"
        assert_text "Evento 9"
    end

    test "PI33 - Destroy_register" do
        find(".dropdown button", text: "Profile").click
        click_on "My Registers"
        user = users(:prueba2)
        register_id = user.registers.first.id
        click_on "interactuable_#{register_id}"
        find(".dropdown button", text: "Edit").click
        click_on "Delete Register"
        assert_current_path "/users/#{user.id}/registers"
        assert_no_selector "interactuable_#{register_id}"
    end

end
