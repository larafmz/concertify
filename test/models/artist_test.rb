require "test_helper"

class ArtistTest < ActiveSupport::TestCase
    fixtures :all

    test "PU04 - Create_artists" do
        TicketmasterService.stub :artist_by_id, {"name"=>"Miley Cyrus", "id"=> "1"} do
            artist1 = Artist.create_or_update_by_ticketmaster_id("1")
            assert artist1.persisted?
            assert_equal "Miley Cyrus", artist1.name
        end
    end

    test "PU05 - Create_artists_unexistent" do
        TicketmasterService.stub :artist_by_id, nil do
            artist2 = Artist.create_or_update_by_ticketmaster_id("2")
            assert_nil artist2
        end
    end

    test "PU06 - Create_artists_existent" do
        TicketmasterService.stub :artist_by_id, {"name"=>"Dua Lipa", "id"=> "3"} do
            artist3 = artists(:artist3)
            Artist.create_or_update_by_ticketmaster_id(artist3.ticketmaster_id)
            artist3.reload
            assert_not_equal "Artista antiguo1", artist3.name
            assert_equal "Dua Lipa", artist3.name
        end
    end

    test "PU07 - Create_artists_existent_2" do
        TicketmasterService.stub :artist_by_id, {"name"=>"Michael Jackson", "id"=> "4"} do
            artist4 = artists(:artist4)
            Artist.create_or_update_by_ticketmaster_id(artist4.ticketmaster_id)
            artist4.reload
            assert_not_equal "Michael Jackson", artist4.name
            assert_equal "Artista antiguo2", artist4.name
        end
    end

    test "PU21 - Search_artists_without_filters" do
        response_api = [
            {"name"=>"Miley Cyrus", "id"=> "3"}, 
            {"name"=>"Dua Lipa", "id"=> "4"}, 
        ]
        TicketmasterService.stub :artists_by, response_api do
            artists = Artist.search_by
            assert_equal 5, artists.length
            assert_equal artists[0][:artist].name, "Leiva"
            assert_equal artists[1][:artist].name, "Rihanna"
            assert_equal artists[2][:artist].name, "Kesha"
            assert_equal artists[3][:artist]["name"], "Miley Cyrus"
            assert_equal artists[4][:artist]["name"], "Dua Lipa"
        end
    end

    test "PU22 - Search_artists_by_name" do
        TicketmasterService.stub :artists_by, nil do
            artists = Artist.search_by(params: {search: "ihan"})
            assert_equal 1, artists.length
            assert_equal artists[0][:artist].name, "Rihanna"
        end
    end

    test "PU23 - Search_artists_by_genre" do
        TicketmasterService.stub :artists_by, nil do
            artists = Artist.search_by(params: {genre_id: genres(:rock).id})
            assert_equal 1, artists.length
            assert_equal artists[0][:artist].name, "Leiva"
        end
    end

    test "PU24 - Search_artists_by_filters" do
        TicketmasterService.stub :artists_by, nil do
            artists = Artist.search_by(params: {search: "Rihanna", genre_id: genres(:pop).id})
            assert_equal 1, artists.length
            assert_equal artists[0][:artist].name, "Rihanna"
        end
    end

end
