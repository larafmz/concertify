require "test_helper"

class InteractuableTest < ActiveSupport::TestCase
    fixtures :all

    test "PU65 - like" do
        registers(:register1).like(users(:prueba3).id)
        assert_equal registers(:register1).likes.count, 1
        assert_equal registers(:register1).likes.first.user, users(:prueba3)
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
    end

    test "PU66 - comment" do
        registers(:register1).comment(users(:prueba3).id, "Genial")
        assert_equal registers(:register1).comments.count, 1
        assert_equal registers(:register1).comments.first.user, users(:prueba3)
        assert_equal registers(:register1).comments.first.text, "Genial"
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
    end

    test "PU67 - repost" do
        registers(:register1).repost(users(:prueba3).id)
        assert_equal registers(:register1).reposts.count, 1
        assert_equal registers(:register1).reposts.first.user, users(:prueba3)
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
    end

    test "PU68 - reply" do
        registers(:register1).comment(users(:prueba3).id, "Genial")
        registers(:register1).comments.first.reply(users(:prueba2).id, "Gracias")
        assert_equal registers(:register1).comments.first.replies.count, 1
        assert_equal registers(:register1).comments.first.replies.first.text, "Gracias"
        assert_equal Notification.all.count, 2
        assert_equal Notification.all.last.recipient_id, users(:prueba3).id 
    end

    test "PU69 - reply_to_reply" do
        registers(:register1).comment(users(:prueba3).id, "Genial")
        registers(:register1).comments.first.reply(users(:prueba2).id, "Gracias")
        registers(:register1).comments.first.replies.first.reply(users(:prueba4).id, "Genial x2")
        assert_equal registers(:register1).comments.first.replies.first.replies.count, 1
        assert_equal Notification.all.count, 4
        assert_equal Notification.all[2].recipient_id, users(:prueba2).id
        assert_equal Notification.all[3].recipient_id, users(:prueba3).id
    end

    test "PU70 - like_self" do
        registers(:register1).like(users(:prueba2).id)
        assert_equal registers(:register1).likes.count, 0
        assert_equal Notification.all.count, 0
    end

    test "PU71 - comment_self" do
        registers(:register1).comment(users(:prueba2).id, "Tengo razón")
        assert_equal registers(:register1).comments.count, 1
        assert_equal registers(:register1).comments.first.user, users(:prueba2)
        assert_equal registers(:register1).comments.first.text, "Tengo razón"
        assert_equal Notification.all.count, 0
    end

    test "PU72 - repost_self" do
        registers(:register1).repost(users(:prueba2).id)
        assert_equal registers(:register1).reposts.count, 1
        assert_equal registers(:register1).reposts.first.user, users(:prueba2)
        assert_equal Notification.all.count, 0
    end

    test "PU73 - like_blocked_by_me" do
        registers(:register1).like(users(:blocked_by).id)
        assert_equal registers(:register1).likes.count, 0
        assert_equal Notification.all.count, 0
    end

    test "PU74 - comment_blocked_by_me" do
        registers(:register1).comment(users(:blocked_by).id, "No sale porque le he bloqueado")
        assert_equal registers(:register1).comments.count, 0
        assert_equal Notification.all.count, 0
    end

    test "PU75 - repost_blocked_by_me" do
        registers(:register1).repost(users(:blocked_by).id)
        assert_equal registers(:register1).reposts.count, 0
        assert_equal Notification.all.count, 0
    end

    test "PU76 - reply_blocked_by_me" do
        registers(:register1).comment(users(:prueba3).id, "Genial")
        registers(:register1).comments.first.reply(users(:blocked_by).id, "No sale porque le he bloqueado")
        assert_equal registers(:register1).comments.first.replies.count, 0
        assert_equal Notification.all.count, 1
    end

    test "PU77 - reply_blocked_me" do
        registers(:register1).comment(users(:prueba3).id, "Genial")
        registers(:register1).comments.first.reply(users(:blocked_me).id, "No sale porque me ha bloqueado")
        assert_equal registers(:register1).comments.first.replies.count, 0
        assert_equal Notification.all.count, 1
    end

    test "PU78 - like_blocked_me" do
        registers(:register1).like(users(:blocked_me).id)
        assert_equal registers(:register1).likes.count, 0
        assert_equal Notification.all.count, 0
    end

    test "PU79 - comment_blocked_by_me" do
        registers(:register1).comment(users(:blocked_me).id, "No sale porque me ha bloqueado")
        assert_equal registers(:register1).comments.count, 0
        assert_equal Notification.all.count, 0
    end
    
    test "PU80 - repost_blocked_me" do
        registers(:register1).repost(users(:blocked_me).id)
        assert_equal registers(:register1).reposts.count, 0
        assert_equal Notification.all.count, 0
    end

end