require "application_system_test_case"

class LoggingTest < ApplicationSystemTestCase
    fixtures :all

    test "PI05 - user_logging" do
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 

            fill_in "email_id", with: "prueba2@gmail.com"
            fill_in "password_id", with: "Prueba2!"

            click_on "Log in"
            assert_current_path "/", wait: 10
            visit "/users/edit"
            assert_current_path "/users/edit", wait: 10
        end
    end

    test "PI06 - user_logging_inexistent_user" do
        visit "/users/sign_in" 

        fill_in "email_id", with: "prueba@gmail.com"
        fill_in "password_id", with: "Prueba2!"

        click_on "Log in"
        assert_text "Invalid email or password.", wait: 5
        assert_current_path "/users/sign_in"
    end

    test "PI07 - user_logging_incorrect_password" do
        visit "/users/sign_in" 

        fill_in "email_id", with: "prueba2@gmail.com"
        fill_in "password_id", with: "Prueba1!"

        click_on "Log in"
        assert_text "Invalid email or password", wait: 5
        assert_current_path "/users/sign_in"
    end


end