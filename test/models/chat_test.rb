require "test_helper"

class ChatTest < ActiveSupport::TestCase
    fixtures :all

    # PU55
    test "Create_private_chat" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:prueba3).id)
        assert chat.persisted?
        assert_equal chat.chat_users.count, 2
        assert_equal chat.chat_users[0].user, users(:prueba2)
        assert_equal chat.chat_users[1].user, users(:prueba3)
    end

    # PU56 // PU57 // PU58
    test "Create_event_chat" do
        chat = Chat.create_event_chat(events(:event3).id, users(:prueba2).id)
        assert chat.persisted?
        assert_equal chat.chat_entries.count, 1
        assert_equal chat.chat_users.count, 1
        assert_equal chat.event, events(:event3)
        assert_equal chat.chat_users[0].user, users(:prueba2)

        chat2 = Chat.create_event_chat(events(:event4).id, users(:prueba2).id)
        assert chat2.persisted?
        assert_equal chat2.chat_entries.count, 1
        assert_equal chat2.chat_users.count, 1
        assert_equal chat2.event, events(:event4)
        assert_equal chat2.chat_users[0].user, users(:prueba2)

        chat3 = Chat.create_event_chat(events(:event5).id, users(:prueba2).id)
        assert chat3.persisted?
        assert_equal chat3.chat_users.count, 0
    end

    # PU59
    test "Create_chat_of_unexisting_event" do
        assert_raises(ActiveRecord::InvalidForeignKey) do
            Chat.create_event_chat(132312, users(:prueba2).id)
        end
    end

    # PU60
    test "send_message_to_private_chat" do
        chat = Chat.create_private_chat(users(:prueba2).id, users(:prueba3).id)
        users(:prueba3).chat_users.first.mark_as_read
        assert users(:prueba3).chat_users.first.read?

        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert message.persisted?
        assert_equal chat.chat_entries.count, 1
        assert_equal chat.chat_entries[0], message
        assert_equal message.text, "Hola!"
        assert_not users(:prueba3).chat_users.first.read?
        assert_equal users(:prueba3).chat_users.unread.size, 1
    end

    test "send_message_to_event_chat_and_exit" do
        # PU61
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
        
        # PU62
        chat.exit_chat(users(:prueba2).id)
        assert_equal chat.chat_entries.count, 5
        assert_equal chat.chat_entries[3], message
        assert_equal chat.chat_users.count, 2
    end

    test "send_message_to_blocked_users" do
        # PU63
        chat = Chat.create_private_chat(users(:prueba2).id, users(:blocked_by).id)
        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert_not message.persisted?
        assert_equal chat.chat_entries.count, 0

        # PU63
        chat = Chat.create_private_chat(users(:prueba2).id, users(:blocked_me).id)
        message = chat.send_message(users(:prueba2).id, "Hola!")
        assert_not message.persisted?
        assert_equal chat.chat_entries.count, 0

    end

end