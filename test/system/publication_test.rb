require "application_system_test_case"

class PublicationTest < ApplicationSystemTestCase
    fixtures :all

    setup do
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "prueba2@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "Log in"
            assert_current_path "/", wait: 15
        end
    end

    test "PI45 - Create_publication" do
        click_on "post_id"
        text = Faker::Lorem.characters(number: 501)
        fill_in "review_id", with: text
        files = Array.new(4) { Rails.root.join("test/fixtures/files/profile.jpeg") }
        attach_file "photos_id", files
        click_on "Post"
        publication = Publication.last
        assert_current_path "/interactuables/#{publication.id}", wait: 10
        assert_no_text text
        assert_text text[0...-1]
        assert_selector ".publication-photo", count: 4
    end

    test "PI47 - Create_publication_for_artist" do
        TicketmasterService.stub :artist_by_id, [] do
            artist = artists(:artist5)
            visit "/artists/#{artist.id}/publications"
            text = Faker::Lorem.characters(number: 501)
            fill_in "post_text_id", with: text
            click_on "Post"
            publication = Publication.last
            assert_current_path "/interactuables/#{publication.id}", wait: 10
            assert_no_text text
            assert_text text[0...-1]
            assert_text artist.name
        end
    end

    test "PI47 - Create_publication_for_event" do
        TicketmasterService.stub :event_by_id, [] do
            event = events(:event5)
            visit "/events/#{event.id}/publications"
            text = Faker::Lorem.characters(number: 501)
            fill_in "post_text_id", with: text
            click_on "Post"
            publication = Publication.last
            puts publication.inspect
            assert_current_path "/interactuables/#{publication.id}", wait: 10
            assert_no_text text
            assert_text text[0...-1]
            assert_text event.tour_name
        end
    end

    test "PI48 - Destroy_publication" do
        find(".dropdown button", text: "Profile").click
        click_on "My Publications"
        user = users(:prueba2)
        publication_id = user.publications.last.id
        find(".dropdown button", text: "⁝").click
        accept_confirm do
            click_on "destroy_publication_#{publication_id}"
        end
        assert_current_path "/users/#{user.id}/publications"
        assert_no_selector "publication-#{publication_id}"
    end

end
