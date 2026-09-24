require "test_helper"

class PublicationTest < ActiveSupport::TestCase
    fixtures :all

    test "PU47 - Create_publication" do
        publication = Publication.new(user: users(:prueba2), review: "Hoy ha sido un día increíble" )
        4.times do
            publication.photos.attach(
            io: StringIO.new("fake image"),
            filename: "photo.jpg",
            content_type: "image/jpeg"
            )
        end
        assert publication.valid?
        publication.save
        assert publication.persisted?
        assert_equal publication.review, "Hoy ha sido un día increíble"
        assert_equal publication.type, "Publication"
    end

    test "PU48 - Create_publication_on_artist" do
        publication = Publication.new(user: users(:prueba2), review: "Me encanta este artista", artist: artists(:artist3) )
        assert publication.valid?
        publication.save
        assert publication.persisted?
        assert_equal publication.review, "Me encanta este artista"
        assert_equal publication.type, "Publication"
    end

    test "PU49 - Create_publication_on_unaccepted_artist" do
        publication = Publication.new(user: users(:prueba2), review: "Me encanta este artista", artist: artists(:artist8) )
        assert_not publication.valid?
        publication.save
        assert_not publication.persisted?
    end

    test "PU50 - Create_publication_on_event" do
        publication = Publication.new(user: users(:prueba2), review: "Ojalá haber ido", event: events(:event3) )
        assert publication.valid?
        publication.save
        assert publication.persisted?
        assert_equal publication.review, "Ojalá haber ido"
        assert_equal publication.type, "Publication"
    end

    test "PU51 - Create_publication_on_unaccepted_event" do
        publication = Publication.new(user: users(:prueba2), review: "Ojalá haber ido", event: events(:event8) )
        assert_not publication.valid?
        publication.save
        assert_not publication.persisted?
    end

    test "PU52 - Create_publication_with_over_4_photos" do
        publication = Publication.new(user: users(:prueba2), review: "Demasiadas fotos!")
        5.times do
            publication.photos.attach(
            io: StringIO.new("fake image"),
            filename: "photo.jpg",
            content_type: "image/jpeg"
            )
        end
        assert_not publication.valid?
        publication.save
        assert_not publication.persisted?
    end

    test "PU53 - Create_publication_with_over_500_characters" do
        publication = Publication.new(user: users(:prueba2), review: Faker::Lorem.characters(number: 501))
        assert_not publication.valid?
        publication.save
        assert_not publication.persisted?
    end

    test "PU54 - Create_publication_without_text" do
        publication = Publication.new(user: users(:prueba2))
        assert_not publication.valid?
        publication.save
        assert_not publication.persisted?
    end

end
