require "test_helper"

class FavoriteArtistTest < ActiveSupport::TestCase
    fixtures :all

    test "PU90 - mark_as_favorite" do
        users(:prueba2).mark_as_favorite(artists(:artist3))
        assert_equal FavoriteArtist.all.count, 1
        assert_equal FavoriteArtist.last.user, users(:prueba2)
        assert_equal FavoriteArtist.last.artist, artists(:artist3)
        assert FavoriteArtist.last.artist, users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 1
    end

    test "PU91 - cant_mark_as_favorite" do
        users(:prueba2).mark_as_favorite(artists(:artist3))
        users(:prueba2).mark_as_favorite(artists(:artist4))
        users(:prueba2).mark_as_favorite(artists(:artist5))
        users(:prueba2).mark_as_favorite(artists(:artist6))
        assert_not users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 4
        users(:prueba2).mark_as_favorite(artists(:artist7))
        assert_equal users(:prueba2).favorite_artists.count, 4
    end

    test "PU92 - unmark_as_favorite" do
        users(:prueba2).mark_as_favorite(artists(:artist3))
        users(:prueba2).mark_as_favorite(artists(:artist4))
        users(:prueba2).mark_as_favorite(artists(:artist5))
        users(:prueba2).mark_as_favorite(artists(:artist6))
        users(:prueba2).unmark_as_favorite(artists(:artist3))
        assert users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 3
    end

end