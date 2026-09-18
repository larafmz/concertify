require "test_helper"

class RegisterTest < ActiveSupport::TestCase
    fixtures :all

    test "Create_registers" do

        # PU25
        register1 = Register.new(user: users(:prueba2), event: events(:event3), review: Faker::Lorem.characters(number: 500), rating: 5)
        10.times do
            register1.photos.attach(
            io: StringIO.new("fake image"),
            filename: "photo.jpg",
            content_type: "image/jpeg"
            )
        end
        assert register1.valid?
        register1.save
        assert register1.persisted?
        assert register1.review.present?
        assert_equal register1.type, "Register"
        assert_equal register1.rating, 5

    end

    test "Create_register_to_non_accepted_event" do

        # PU26
        register2 = Register.create(user: users(:prueba2), event: events(:event8))
        assert_not register2.persisted?
    
    end

    test "Create_register_to_posterior_event" do
        # PU27

        register3 = Register.create(user: users(:prueba2), event: events(:event5))
        assert_not register3.persisted?
    end

    test "Create_register_to_same_date_posterior_time_event" do

        # PU28
        register4 = Register.create(user: users(:prueba2), event: events(:event4))
        assert_not register4.persisted?
    
    end

    test "Create_register_to_same_date_past_time_event" do

        # PU29
        register5 = Register.create!(user: users(:prueba2), event: events(:event9))
        assert register5.persisted?
    end

    test "Create_register_with_over_10_photos" do

        # PU30
        register6 = Register.new(user: users(:prueba2), event: events(:event9))
        11.times do
            register6.photos.attach(
            io: StringIO.new("fake image"),
            filename: "photo.jpg",
            content_type: "image/jpeg"
            )
        end
        assert_not register6.valid?

    end

    test "Create_register_with_invalid_rating" do

        # PU31
        register7 = Register.create(user: users(:prueba2), event: events(:event3), rating: 1.5)
        assert_not register7.persisted?

        # PU32
        register8 = Register.create(user: users(:prueba2), event: events(:event3), rating: 6)
        assert_not register8.persisted?

    end

    test "Create_register_with_invalid_review" do

        # PU33
        register9 = Register.create(user: users(:prueba2), event: events(:event3), review: Faker::Lorem.characters(number: 501))
        assert_not register9.persisted?

    end

    test "Create_register_but_already_exists" do

        # PU34
        register = Register.create(user: users(:prueba2), event: events(:event3))
        assert register.persisted?
        register2 = Register.create(user: users(:prueba2), event: events(:event3))
        assert_not register2.persisted?

    end


end
