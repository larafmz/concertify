require "application_system_test_case"

class ChatTest < ApplicationSystemTestCase
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

    test "PI49 - private_chat_first_time" do
        setup_user2
        user2 = users(:prueba3)
        visit "/users/#{user2.id}" 
        click_on "Send message"
        assert_text user2.username
        message = Faker::Lorem.characters(number: 501)
        fill_in "chat_text_area_id", with: message
        click_on "submit_message_id"
        chat = Chat.last
        assert_selector "#chat_#{chat.id}", wait: 10
        assert_selector ".chat_entry", count: 1
        assert_text "Sent"
        assert_no_text message
        assert_text message[0...-1]
        assert_text I18n.l(Date.today, format: "%-d %b")
    end

    test "PI50 - private_chat_not_first_time" do
        setup_user3
        user3 = users(:prueba3)
        admin = users(:admin)
        visit "/users/#{admin.id}" 
        click_on "Send message"
        assert_text admin.username
        user3.chats.each do |chat|
            assert_selector "#chat_#{chat.id}", wait: 10
        end
        actual_chat = user3.chats.find { |chat| chat.chat_users.any? { |cu| cu.user_id == admin.id } }
        first_chat = all(".sidebar_chat").first
        assert_not_equal "chat_#{actual_chat.id}", first_chat[:id]

        message = Faker::Lorem.characters(number: 501)
        fill_in "chat_text_area_id", with: message
        click_on "submit_message_id"

        sleep 5
        assert_equal "chat_#{actual_chat.id}", all(".sidebar_chat").first[:id]

        assert_selector ".chat_entry", count: 3
        assert_no_text message
        assert_text message[0...-1]
    end

    test "PI51 - event_chat_with_register" do
        setup_user2
        register = users(:prueba2).registers.first
        event = register.event
        visit "/events/#{event.id}" 
        click_on "Access Chat"
        assert_current_path "/chats/#{event.id}?event_id=#{event.id}", wait: 10
        assert_text event.tour_name
        assert_text "1 Members"
        assert_text "You joined the group"
        assert_selector "#chat_text_area_id"
        assert_selector "#submit_message_id"
    end

    test "PI52 - event_chat_with_future_assistance" do
        setup_user2
        future_assistance = users(:prueba2).future_assistances.first
        event = future_assistance.event
        visit "/events/#{event.id}" 
        click_on "Access Chat"
        assert_current_path "/chats/#{event.id}?event_id=#{event.id}", wait: 10
        assert_text event.tour_name
        assert_text "1 Members"
        assert_text "You joined the group"
        assert_selector "#chat_text_area_id"
        assert_selector "#submit_message_id"
    end

    test "PI53 - event_chat_without_assistance" do
        setup_user2
        event = events(:event4)
        visit "/events/#{event.id}" 
        assert_no_text "Access Chat"
    end

    test "PI54 - event_chat_without_assistance" do
        setup_user3
        event = events(:event5)
        chat = Chat.find_by(event_id: event.id)
        visit "/events/#{event.id}" 
        click_on "Access Chat"
        assert_selector "#chat_#{chat.id}", wait: 10
        find(".dropdown button", text: "⁝").click
        click_on "Leave Group"
        assert_current_path "/chats", wait: 10
        assert_no_selector "#chat_#{chat.id}"
    end

    test "PI55 - receives_message" do
        setup_user3
        assert_selector "#chat_header_id", wait: 10
        assert_no_selector ".message_notification"
        assert_selector "#messages_header", wait: 10
        sleep 1 #synchronization
        chat_entry = ChatEntry.create!(chat: chats(:chat1), user: users(:prueba4), text: "Nuevo mensaje!", chat_type: 0)
        assert_selector ".message_notification", wait: 10
        assert_selector ".message_notification", text: "1"
        click_on "chat_header_id"
        assert_current_path "/chats", wait: 10
        assert_equal "chat_#{chats(:chat1).id}", all(".sidebar_chat").first[:id]
        #color is different cause one chat is read and the other is not
        assert_not_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
        click_on "chat_link_#{chats(:chat1).id}"
        assert_text "Nuevo mensaje!", wait: 10
        #color is the same cause both are read now
        assert_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
    end

    test "PI56 - receives_message_in_chats_view" do
        setup_user3
        click_on "chat_header_id"
        assert_current_path "/chats", wait: 10
        #color is the same cause both are read
        assert_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
        assert_selector "#chat_header_id", wait: 10
        assert_no_selector ".message_notification"
        assert_selector "#messages_header", wait: 10
        sleep 1 #synchronization
        chat_entry = ChatEntry.create!(chat: chats(:chat1), user: users(:prueba4), text: "Nuevo mensaje!", chat_type: 0)
        assert_selector ".message_notification", wait: 10
        assert_selector ".message_notification", text: "1"
        assert_equal "chat_#{chats(:chat1).id}", all(".sidebar_chat").first[:id]
        #color is different cause one chat is read and the other is not
        assert_not_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
    end

    test "PI57 - receives_message_inside_chat" do
        setup_user3
        click_on "chat_header_id"
        assert_current_path "/chats", wait: 10
        #color is the same cause both are read
        assert_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
        click_on "chat_link_#{chats(:chat1).id}"
        chat_entry = ChatEntry.create!(chat: chats(:chat1), user: users(:prueba4), text: "Nuevo mensaje!", chat_type: 0)
        assert_text "Nuevo mensaje!", wait: 10
        assert_no_selector ".message_notification"
        assert_equal "chat_#{chats(:chat1).id}", all(".sidebar_chat").first[:id]
        #color is different cause one chat is read and the other is not
        assert_not_equal(
            find("#chat_name_#{chats(:chat1).id}")["style"],
            find("#chat_name_#{chats(:chat2).id}")["style"]
        )
    end




end