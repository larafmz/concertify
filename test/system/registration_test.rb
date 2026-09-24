require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
    fixtures :all

    test "PI01 - user_register" do
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_up" 

            fill_in "username_id", with: "prueba"
            fill_in "email_id", with: "prueba@gmail.com"
            fill_in "password_id", with: "Prueba1!"
            fill_in "password_confirmation_id", with: "Prueba1!"

            click_on "Create account"
            assert_no_text "Username", wait: 5
            assert_current_path "/"
            assert_not_nil User.find_by(email: "prueba@gmail.com")
            
            visit "/users/edit"
            assert_current_path "/users/edit"
            assert_text "Username", wait: 5
        end
    end

    test "PI02 - user_register_existent_username" do
        visit "/users/sign_up" 

        fill_in "username_id", with: "prueba2"
        fill_in "email_id", with: "prueba@gmail.com"
        fill_in "password_id", with: "Prueba1!"
        fill_in "password_confirmation_id", with: "Prueba1!"

        click_on "Create account"
        assert_text "Username has already been taken", wait: 5
        assert_current_path "/users/sign_up"
        assert_nil User.find_by(email: "prueba@gmail.com")

        visit "/users/edit"
        assert_current_path "/users/sign_in"
        assert_text "You need to sign in or sign up before continuing."
    end

    test "PI03 - user_register_existent_email" do
        visit "/users/sign_up" 

        fill_in "username_id", with: "prueba"
        fill_in "email_id", with: "prueba2@gmail.com"
        fill_in "password_id", with: "Prueba1!"
        fill_in "password_confirmation_id", with: "Prueba1!"

        click_on "Create account"
        assert_text "Email has already been taken", wait: 5
        assert_current_path "/users/sign_up"
        assert_nil User.find_by(username: "prueba")
    end

    test "PI04 - user_register_unmatching_passwords" do
        visit "/users/sign_up" 

        fill_in "username_id", with: "prueba"
        fill_in "email_id", with: "prueba2@gmail.com"
        fill_in "password_id", with: "Prueba1!"
        fill_in "password_confirmation_id", with: "Prueba2!"

        click_on "Create account"
        assert_text "Password confirmation doesn't match Password", wait: 5
        assert_current_path "/users/sign_up"
        assert_nil User.find_by(username: "prueba")
    end

end