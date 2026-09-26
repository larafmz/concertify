require "application_system_test_case"
include ActiveJob::TestHelper

class RelationTest < ApplicationSystemTestCase
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

    test "PI64 - follow_user" do
        user3 = users(:prueba3)
        find(".dropdown button", text: "View").click
        click_on "Users"
        assert_selector "#follow_#{user3.id}"
        assert_no_selector "#unfollow_#{user3.id}"
        click_on "follow_#{user3.id}"
        assert_selector "#unfollow_#{user3.id}"
        assert_no_selector "#follow_#{user3.id}"
    end

    test "PI65 - unfollow_user" do
        user3 = users(:prueba3)
        find(".dropdown button", text: "View").click
        click_on "Users"
        assert_selector "#follow_#{user3.id}"
        assert_no_selector "#unfollow_#{user3.id}"
        click_on "follow_#{user3.id}"
        assert_selector "#unfollow_#{user3.id}"
        assert_no_selector "#follow_#{user3.id}"
        click_on "unfollow_#{user3.id}"
        assert_selector "#follow_#{user3.id}"
        assert_no_selector "#unfollow_#{user3.id}"
    end

    test "PI66 - block_user" do
        user3 = users(:prueba3)
        find(".dropdown button", text: "View").click
        click_on "Users"
        click_on "link_user_#{user3.id}"
        assert_text "Follow"
        assert_text "Send message"
        find(".dropdown .dropdown-toggle", text: "⁝").click
        click_on "Block"
        assert_no_text "Follow"
        assert_no_text "Send message"
        assert_text "BLOCKED"
        find(".dropdown .dropdown-toggle", text: "⁝").click
        assert_text "Unblock"
    end

    test "PI67 - unblock_user" do
        user3 = users(:prueba3)
        find(".dropdown button", text: "View").click
        click_on "Users"
        click_on "link_user_#{user3.id}"
        assert_text "Send message", wait: 10
        assert_text "Follow"
        find(".dropdown .dropdown-toggle", text: "⁝").click
        click_on "Block"
        assert_no_text "Follow"
        assert_no_text "Send message"
        assert_text "BLOCKED"
        find(".dropdown .dropdown-toggle", text: "⁝").click
        assert_text "Unblock"
        click_on "Unblock"
        assert_text "Follow", wait: 10
        assert_text "Send message"
        assert_no_text "BLOCKED"
    end

    test "PI68 - remove_follower" do
        user3 = users(:prueba3)
        perform_enqueued_jobs do
            Relation.create!(follower: user3, followed: users(:prueba2), relation_type: 0)
        end
        find(".dropdown button", text: "View").click
        click_on "Users"
        click_on "link_user_#{user3.id}"
        assert_text "Send message", wait: 10
        assert_text "Follow"
        assert_text "Follows you"
        find(".dropdown .dropdown-toggle", text: "⁝").click
        click_on "Delete Follower"
        assert_current_path "/users/#{user3.id}", wait: 10
        assert_no_text "Follows you", wait: 10
    end
    
    test "PI69 - gets_followed" do
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        sleep 1 #synchronization
        perform_enqueued_jobs do
            Relation.create!(follower: users(:prueba3), followed: users(:prueba2), relation_type: 0)
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:prueba2).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "#{users(:prueba3).username} has started following you"
    end

end