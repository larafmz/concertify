require "test_helper"

class ChatTest < ActiveSupport::TestCase
    fixtures :all

    test "PU55 - Create_private_chat" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:prueba3).id)
        assert chat.persisted?
        assert_equal chat.chat_users.count, 2
        assert_equal chat.chat_users[0].user, users(:prueba2)
        assert_equal chat.chat_users[1].user, users(:prueba3)
    end

    test "PU56 - Create_event_chat_with_future_assistance" do
        chat = Chat.create_event_chat(events(:event3).id, users(:prueba2).id)
        assert chat.persisted?
        assert_equal chat.chat_entries.count, 1
        assert_equal chat.chat_users.count, 1
        assert_equal chat.event, events(:event3)
        assert_equal chat.chat_users[0].user, users(:prueba2)
    end

    test "PU57 - Create_event_chat_with_register" do
        chat2 = Chat.create_event_chat(events(:event9).id, users(:prueba2).id)
        assert chat2.persisted?
        assert_equal chat2.chat_entries.count, 1
        assert_equal chat2.chat_users.count, 1
        assert_equal chat2.event, events(:event9)
        assert_equal chat2.chat_users[0].user, users(:prueba2)
    end

    test "PU58 - Create_event_chat_without_assistance" do
        chat3 = Chat.create_event_chat(events(:event6).id, users(:prueba2).id)
        assert chat3.persisted?
        assert_equal chat3.chat_users.count, 0
    end

    test "PU59 - Create_chat_of_unexisting_event" do
        assert_raises(ActiveRecord::InvalidForeignKey) do
            Chat.create_event_chat(132312, users(:prueba2).id)
        end
    end

    test "PU60 - send_message_to_private_chat" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:prueba3).id)
        users(:prueba3).chat_users.last.mark_as_read
        assert users(:prueba3).chat_users.last.read?

        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert message.persisted?
        assert_equal chat.chat_entries.count, 1
        assert_equal chat.chat_entries[0], message
        assert_equal message.text, "Hola!"
        assert_not users(:prueba3).chat_users.last.read?
        assert_equal users(:prueba3).chat_users.unread.size, 1
    end

    test "PU61 - send_message_to_event_chat" do
        chat = Chat.create_event_chat(events(:event3).id, users(:prueba2).id)
        chat = Chat.create_event_chat(events(:event3).id, users(:blocked_by).id)
        chat = Chat.create_event_chat(events(:event3).id, users(:blocked_me).id)
        assert_equal chat.chat_users.count, 3

        users(:blocked_by).chat_users.first.mark_as_read
        users(:blocked_me).chat_users.first.mark_as_read

        message = chat.send_message(users(:prueba2).id, "Hola a todos!")
        assert message.persisted?
        assert_equal chat.chat_entries.count, 4
        assert_equal chat.chat_entries[3], message
        assert_equal message.text, "Hola a todos!"
        assert_not users(:blocked_by).chat_users.first.read?
        assert_not users(:blocked_me).chat_users.first.read?
        assert_equal users(:blocked_by).chat_users.unread.size, 1
        assert_equal users(:blocked_me).chat_users.unread.size, 1
    end

    test "PU62 - exit_event_chat" do
        chat = Chat.create_event_chat(events(:event3).id, users(:prueba2).id)
        chat = Chat.create_event_chat(events(:event3).id, users(:blocked_by).id)
        chat = Chat.create_event_chat(events(:event3).id, users(:blocked_me).id)
        message = chat.send_message(users(:prueba2).id, "Hola a todos!")
        chat.exit_chat(users(:prueba2).id)
        assert_equal chat.chat_entries.count, 5
        assert_equal chat.chat_entries[3], message
        assert_equal chat.chat_users.count, 2
    end

    test "PU63 - send_message_to_blocked_user" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:blocked_by).id)
        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert_not message.persisted?
        assert_equal chat.chat_entries.count, 0
    end

    test "PU64 - send_message_to_user_who_blocked_me" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:blocked_me).id)
        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert_not message.persisted?
        assert_equal chat.chat_entries.count, 0
    end

end