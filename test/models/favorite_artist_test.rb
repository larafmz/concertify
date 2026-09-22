require "test_helper"

class FavoriteArtistTest < ActiveSupport::TestCase
    fixtures :all

    test "mark_as_favorite" do
        # PU90
        users(:prueba2).mark_as_favorite(artists(:artist3))
        assert_equal FavoriteArtist.all.count, 1
        assert_equal FavoriteArtist.last.user, users(:prueba2)
        assert_equal FavoriteArtist.last.artist, artists(:artist3)
        assert FavoriteArtist.last.artist, users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 1

        users(:prueba2).mark_as_favorite(artists(:artist4))
        users(:prueba2).mark_as_favorite(artists(:artist4))
        users(:prueba2).mark_as_favorite(artists(:artist5))
        users(:prueba2).mark_as_favorite(artists(:artist6))
        assert_not users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 4

        # PU91
        users(:prueba2).mark_as_favorite(artists(:artist7))
        assert_equal users(:prueba2).favorite_artists.count, 4

        # PU92
        users(:prueba2).unmark_as_favorite(artists(:artist3))
        assert users(:prueba2).can_mark_favorite?
        assert_equal users(:prueba2).favorite_artists.count, 3

        users(:prueba2).mark_as_favorite(artists(:artist7))
        assert_equal users(:prueba2).favorite_artists.count, 4
    end

end