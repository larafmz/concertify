require "application_system_test_case"

class UserManagementTest < ApplicationSystemTestCase
    fixtures :all

    setup do
        visit "/users/sign_in" 
        fill_in "email_id", with: "prueba2@gmail.com"
        fill_in "password_id", with: "Prueba2!"
        click_on "Log in"
        assert_current_path "/", wait: 15
    end

    test "PI08 - edit_user" do
        visit "/users/edit"
        assert_current_path "/users/edit", wait: 10
        find("#username_id").set("nuevo_username")
        find("#email_id").set("prueba1@gmail.com")
        select "Spain", from: "country_id"
        fill_in "city_id", with: "Gijón"
        fill_in "description_id", with: "amante de la música"
        attach_file "user_icon", Rails.root.join("test/fixtures/files/profile.jpeg")

        click_on "Save"
        assert_text "DESCRIPTION", wait: 10
        current_user = User.find_by(email: "prueba1@gmail.com")
        assert_current_path "/users/#{current_user.id}"
        assert_text "nuevo_username"
        assert_text "Spain"
        assert_text "Gijón"
        assert_text "amante de la música"
        assert current_user.icon.attached?
        assert_equal "profile.jpeg", current_user.icon.filename.to_s
    end

    test "PI09 - change_password" do
        visit "/users/edit"
        assert_current_path "/users/edit", wait: 10
        fill_in "Password", with: "nuevaPass"
        fill_in "Password confirmation", with: "nuevaPass"
        fill_in "Current password", with: "Prueba2!"

        click_on "Save"
        assert_text "DESCRIPTION", wait: 10
        current_user = User.find_by(email: "prueba2@gmail.com")
        assert_current_path "/users/#{current_user.id}"
        assert current_user.valid_password?("nuevaPass")
        refute current_user.valid_password?("Prueba2!")
    end

    
    test "PI10 - change_password_without_actual" do
        visit "/users/edit"
        assert_current_path "/users/edit", wait: 10
        fill_in "Password", with: "Prueba1!"
        fill_in "Password confirmation", with: "Prueba1!"

        click_on "Save"
        assert_current_path "/users/edit", wait: 10
        assert_text "Current password can't be blank"
    end

    test "PI11 - log_out" do
        find(".dropdown button", text: "Profile").click
        click_on "Log out"
        assert_current_path "/", wait: 10
        visit "/users/edit"
        assert_current_path "/users/sign_in", wait: 10
    end

    test "PI12 - destroy_account" do
        visit "/users/edit"
        accept_confirm do
            click_on "Delete my account"
        end
        assert_current_path "/", wait: 10
        visit "/users/edit"
        assert_current_path "/users/sign_in", wait: 10
    end

end