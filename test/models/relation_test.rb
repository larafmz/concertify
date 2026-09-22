require "test_helper"

class RelationTest < ActiveSupport::TestCase
    fixtures :all

    test "follow_unfollow_user" do
        # PU81
        users(:prueba2).follow(users(:prueba3))
        assert_equal users(:prueba2).followings.count, 1
        assert_equal users(:prueba3).followers.count, 1
        assert_equal Relation.all.count, 3
        assert_equal Relation.last.follower, users(:prueba2)
        assert_equal Relation.last.followed, users(:prueba3)
        assert_equal Relation.last.relation_type, 0
        assert users(:prueba2).follows_user?(users(:prueba3))

        assert_equal Notification.all.count, 1
        assert_equal Notification.all.last.recipient_id, users(:prueba3).id

        # PU82
        users(:prueba2).unfollow(users(:prueba3))
        assert_equal Relation.all.count, 2
        assert_not users(:prueba2).follows_user?(users(:prueba3))
        assert_equal Notification.all.count, 0
        
    end

    test "block_unblock_user" do
        # PU83
        users(:prueba2).follow(users(:prueba3))
        assert_equal users(:prueba2).followings.count, 1
        assert_equal users(:prueba3).followers.count, 1
        assert_equal Relation.all.count, 3
        users(:prueba2).block(users(:prueba3).id)
        assert_equal Relation.all.count, 3
        assert_equal Relation.last.follower, users(:prueba2)
        assert_equal Relation.last.followed, users(:prueba3)
        assert_equal Relation.last.relation_type, 1
        assert users(:prueba2).blocked_user?(users(:prueba3))
        assert_equal Notification.all.count, 0
        assert_equal users(:prueba2).followings.count, 0
        assert_equal users(:prueba3).followers.count, 0
        assert_equal users(:prueba2).blocked_users.count, 2

        # PU85 // PU86
        users(:prueba2).follow(users(:prueba3))
        users(:prueba3).follow(users(:prueba2))
        assert_equal users(:prueba2).followings.count, 0
        assert_equal users(:prueba3).followings.count, 0
        assert_equal users(:prueba2).followers.count, 0
        assert_equal users(:prueba3).followers.count, 0

        # PU84
        users(:prueba2).unblock(users(:prueba3).id)
        users(:prueba2).unblock(users(:blocked_by).id)
        assert_equal Relation.all.count, 1
        assert_equal Notification.all.count, 0
        assert_equal users(:prueba2).followings.count, 0
        assert_equal users(:prueba3).followers.count, 0
        assert_equal users(:prueba2).blocked_users.count, 0
    end

    # PU87
    test "follow_self" do
        users(:prueba2).follow(users(:prueba2))
        assert_equal users(:prueba2).followings.count, 0
        assert_equal users(:prueba3).followers.count, 0
    end

    test "follow_unfollow_artist" do
        # PU88
        users(:prueba2).follow(artists(:artist3))
        assert_equal artists(:artist3).followers.count, 1
        assert_equal users(:prueba2).followings.count, 1
        assert users(:prueba2).follows_artist?(artists(:artist3))
        assert_equal Relation.all.count, 3
        assert_equal Relation.last.follower, users(:prueba2)
        assert_equal Relation.last.followed, artists(:artist3)
        assert_equal Relation.last.relation_type, 0

        # PU89
        users(:prueba2).unfollow(artists(:artist3))
        assert_equal Relation.all.count, 2
        assert_not users(:prueba2).follows_user?(users(:prueba3))
    end

end