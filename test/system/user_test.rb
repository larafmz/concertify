require "application_system_test_case"

class UserTest < ApplicationSystemTestCase
    fixtures :all

    setup do
        visit "/users/sign_in" 
        fill_in "email_id", with: "prueba2@gmail.com"
        fill_in "password_id", with: "Prueba2!"
        click_on "Log in"
        assert_current_path "/", wait: 15
    end

    test "PI26 - search_users_without_filters" do
        visit "/" 
        find(".dropdown button", text: "View").click
        click_on "Users"
        assert_text "prueba2", wait: 10
        assert_text "prueba3"
        assert_text "prueba4"
        assert_text "admin"
        assert_no_text "blocked_me"
        assert_no_text "blocked_by"
        assert_selector ".register_user", count: 4
    end

    test "PI27 - search_users_by_name" do
        visit "/" 
        find(".dropdown button", text: "View").click
        click_on "Users"
        fill_in "user-filter-search", with: "prueb"
        assert_text "prueba2", wait: 10
        assert_text "prueba3"
        assert_text "prueba4"
        assert_no_text "admin"
        assert_no_text "blocked_by"
        assert_no_text "blocked_me"
        assert_selector ".register_user", count: 3
    end

end