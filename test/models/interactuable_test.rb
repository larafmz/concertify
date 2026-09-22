require "test_helper"

class InteractuableTest < ActiveSupport::TestCase
    fixtures :all

    test "like" do
        # PU65 // PU70 // PU73 // PU78
        registers(:register1).like(users(:prueba3).id)
        registers(:register1).like(users(:prueba2).id)
        registers(:register1).like(users(:blocked_by).id)
        registers(:register1).like(users(:blocked_me).id)
        assert_equal registers(:register1).likes.count, 1
        assert_equal registers(:register1).likes.first.user, users(:prueba3)
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
    end

    test "comment_and_reply" do
        # PU66 // PU71 // PU74 // PU79
        registers(:register1).comment(users(:prueba3).id, "Genial")
        registers(:register1).comment(users(:prueba2).id, "Tengo razón")
        registers(:register1).comment(users(:blocked_by).id, "No sale porque le he bloqueado")
        registers(:register1).comment(users(:blocked_me).id, "No sale porque me ha bloqueado")
        assert_equal registers(:register1).comments.count, 2
        assert_equal registers(:register1).comments.first.user, users(:prueba3)
        assert_equal registers(:register1).comments.first.text, "Genial"
        assert_equal registers(:register1).comments.second.text, "Tengo razón"
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
        
        # PU68 // PU76 // PU77
        registers(:register1).comments.first.reply(users(:prueba2).id, "Gracias")
        registers(:register1).comments.first.reply(users(:blocked_by).id, "No sale porque le he bloqueado")
        registers(:register1).comments.first.reply(users(:blocked_me).id, "No sale porque me ha bloqueado")
        assert_equal registers(:register1).comments.first.replies.count, 1
        assert_equal registers(:register1).comments.first.replies.first.text, "Gracias"
        assert_equal Notification.all.count, 2
        assert_equal Notification.all.last.recipient_id, users(:prueba3).id

        # PU69
        registers(:register1).comments.first.replies.first.reply(users(:prueba4).id, "Genial x2")
        assert_equal registers(:register1).comments.first.replies.first.replies.count, 1
        assert_equal Notification.all.count, 4
        assert_equal Notification.all[3].recipient_id, users(:prueba3).id
        assert_equal Notification.all[2].recipient_id, users(:prueba2).id
    end

    test "repost" do
        # PU67 // PU72 // PU75 // PU80
        registers(:register1).repost(users(:prueba3).id)
        registers(:register1).repost(users(:prueba2).id)
        registers(:register1).repost(users(:blocked_by).id)
        registers(:register1).repost(users(:blocked_me).id)
        assert_equal registers(:register1).reposts.count, 2
        assert_equal registers(:register1).reposts.first.user, users(:prueba3)
        assert_equal registers(:register1).reposts.second.user, users(:prueba2)
        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba2).id
    end

end