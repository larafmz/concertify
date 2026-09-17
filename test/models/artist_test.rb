require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  fixtures :all

  test "Create_artists" do

    TicketmasterService.stub :artist_by_id, {"name"=>"Miley Cyrus", "id"=> "1"} do
        artist1 = Artist.create_or_update_by_ticketmaster_id("1")
        assert artist1.persisted?
        assert_equal "Miley Cyrus", artist1.name
    end

    TicketmasterService.stub :artist_by_id, nil do
        artist2 = Artist.create_or_update_by_ticketmaster_id("2")
        assert_nil artist2
    end

    TicketmasterService.stub :artist_by_id, {"name"=>"Dua Lipa", "id"=> "3"} do
        artist3 = artists(:artist3)
        Artist.create_or_update_by_ticketmaster_id(artist3.ticketmaster_id)
        artist3.reload
        assert_not_equal "Artista antiguo1", artist3.name
        assert_equal "Dua Lipa", artist3.name
    end

    TicketmasterService.stub :artist_by_id, {"name"=>"Michael Jackson", "id"=> "4"} do
        artist4 = artists(:artist4)
        Artist.create_or_update_by_ticketmaster_id(artist4.ticketmaster_id)
        artist4.reload
        assert_not_equal "Michael Jackson", artist4.name
        assert_equal "Artista antiguo2", artist4.name
    end
    
  end

end
