require "application_system_test_case"
include ActiveJob::TestHelper

class InteractuableTest < ApplicationSystemTestCase
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

    test "PI58 - like" do
        setup_user3
        interactuable = registers(:register1)
        visit "/interactuables/#{interactuable.id}" 
        assert_selector "#image_like_#{interactuable.id}", wait: 10
        assert_no_selector "#like_count_#{interactuable.id}"
        assert_no_text users(:prueba3).username
        click_on "like_interactuable_#{interactuable.id}"
        assert_selector "#like_count_#{interactuable.id}", text: "1"
        assert_selector "#image_liked_#{interactuable.id}"
        assert_no_selector "#image_like_#{interactuable.id}"
    end

    test "PI59 - comment" do
        setup_user3
        interactuable = registers(:register1)
        visit "/interactuables/#{interactuable.id}/comments" 
        assert_no_text users(:prueba3).username
        assert_selector "#comment_text_area", wait: 10
        assert_no_selector "#comment_count_#{interactuable.id}"
        fill_in "comment_text_area", with: "Genial"
        click_on "Comment"
        assert_text "less than a minute ago", wait: 10
        assert_selector "#comment_count_#{interactuable.id}", text: "1"
        assert_text users(:prueba3).username
        assert_text "Genial"
    end

    test "PI60 - repost" do
        setup_user3
        interactuable = registers(:register1)
        visit "/interactuables/#{interactuable.id}/reposts" 
        assert_selector "#repost_icon_#{interactuable.id}", wait: 10
        assert_no_selector "#repost_count_#{interactuable.id}"
        assert_no_text users(:prueba3).username
        click_on "repost_interactuable_#{interactuable.id}"
        assert_selector "#repost_count_#{interactuable.id}", text: "1", wait: 10
        assert_selector "#reposted_icon_#{interactuable.id}"
        assert_no_selector "#repost_icon_#{interactuable.id}"
    end

    test "PI61 - gets_like" do
        setup_user2
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        sleep 1 #synchronization
        perform_enqueued_jobs do
            like = Like.create!(user: users(:prueba3), interactuable: registers(:register1))
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:prueba2).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "#{users(:prueba3).username} liked your"
    end

    test "PI62 - gets_comment" do
        setup_user2
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        sleep 1 #synchronization
        perform_enqueued_jobs do
            like = Comment.create!(user: users(:prueba3), interactuable: registers(:register1), text: "Muy buena review")
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:prueba2).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "#{users(:prueba3).username} commented on your"
        assert_text "Muy buena review"
    end

    test "PI63 - gets_repost" do
        setup_user2
        assert_selector "#notifications_header_id", wait: 10
        assert_no_selector ".normal_notification"
        assert_selector "#notifications_header", wait: 10
        sleep 1 #synchronization
        perform_enqueued_jobs do
            repost = Repost.create!(user: users(:prueba3), interactuable: registers(:register1))
        end
        assert_selector ".normal_notification", wait: 10
        assert_selector ".normal_notification", text: "1"
        click_on "notifications_header_id"
        assert_current_path "/users/#{users(:prueba2).id}/notifications", wait: 10
        assert_selector ".notification", count: 1
        assert_text "#{users(:prueba3).username} reposted"
    end

end