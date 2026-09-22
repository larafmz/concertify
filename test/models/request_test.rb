require "test_helper"

class RequestTest < ActiveSupport::TestCase
    fixtures :all

    test "request_event_with_existing_artist_in_db" do
        # PU93
        request = Request.new(requester: users(:prueba2), status: 1)    
        request.event = Event.new(tour_name: "Loud TOUR", date: Date.today, ubication: ubications(:ubication1), start_time: Time.now)
        request.create_artists("Rihanna")
        request.save
        assert request.persisted?
        assert_equal request.requester, users(:prueba2)
        assert_equal request.status, 1
        assert request.event.persisted?
        assert_equal request.event.tour_name, "Loud TOUR"
        assert_equal request.artist, artists(:artist5)
        assert_equal Notification.all.count, 1
        assert_equal Notification.first.recipient, users(:admin)
    end

    test "request_event_with_existing_artist_in_api" do
        # PU94
        request = Request.new(requester: users(:prueba2), status: 1)    
        request.event = Event.new(tour_name: "Debí tirar más fotos TOUR", date: Date.today, ubication: ubications(:ubication2), start_time: Time.now)
        TicketmasterService.stub :artist_by_name, {"name"=>"Bad Bunny", "id"=> "6"} do
            TicketmasterService.stub :artist_by_id, {"name"=>"Bad Bunny", "id"=> "6"} do
                request.create_artists("Bad Bunny")
            end
        end
        request.save
        assert request.persisted?
        assert_equal request.requester, users(:prueba2)
        assert_equal request.status, 1
        assert request.event.persisted?
        assert_equal request.event.tour_name, "Debí tirar más fotos TOUR"
        assert_equal request.artist.name, "Bad Bunny"
        assert_nil request.artist.status
        assert_equal Notification.all.count, 1
        assert_equal Notification.first.recipient, users(:admin)
    end

    test "request_event_with_not_existing_artist" do
        # PU95
        request = Request.new(requester: users(:prueba2), status: 1)    
        request.event = Event.new(tour_name: "Donde está la ONU", date: Date.today, ubication: ubications(:ubication2), start_time: Time.now)
        TicketmasterService.stub :artist_by_name, nil do
            request.create_artists("Niña Polaca")
        end
        request.save
        assert request.persisted?
        assert_equal request.requester, users(:prueba2)
        assert_equal request.status, 1
        assert request.event.persisted?
        assert_equal request.event.tour_name, "Donde está la ONU"
        assert_equal request.artist.name, "Niña Polaca"
        assert_equal request.artist.status, 1
        assert_equal Notification.all.count, 1
        assert_equal Notification.first.recipient, users(:admin)
    end

    test "request_event_without artist" do
        # PU96
        request = Request.new(requester: users(:prueba2), status: 1)    
        request.event = Event.new(tour_name: "Inventado", date: Date.today, ubication: ubications(:ubication2), start_time: Time.now)
        TicketmasterService.stub :artist_by_name, nil do
            request.create_artists(nil)
        end
        request.save
        assert_not request.persisted?
    end

end