require "test_helper"

class FutureAssistanceTest < ActiveSupport::TestCase
    fixtures :all

    # PU35
    test "Create_future_assitance" do
        future_assistance = FutureAssistance.new(user: users(:prueba2), event: events(:event5), from: "Gijón", event_seat_details: "Grada 54", event_seat: 1, company: 1 )
        assert future_assistance.valid?
        future_assistance.save
        assert future_assistance.persisted?
        assert_equal future_assistance.from, "Gijón"
        assert_equal future_assistance.event_seat_details, "Grada 54"
        assert_equal future_assistance.event_seat, 1
        assert_equal future_assistance.company, 1
    end

    # PU36
    test "Create_future_assistance_to_non_accepted_event" do
        future_assistance = FutureAssistance.create(user: users(:prueba2), event: events(:event8))
        assert_not future_assistance.persisted?
    end

    # PU37
    test "Create_future_assistance_to_anterior_event" do
        future_assistance = FutureAssistance.create(user: users(:prueba2), event: events(:event3))
        assert_not future_assistance.persisted?
    end

    # PU38
    test "Create_future_assistance_to_same_date_posterior_time_event" do
        future_assistance = FutureAssistance.create!(user: users(:prueba2), event: events(:event4))
        assert future_assistance.persisted?
    end

    # PU39
    test "Create_future_assistance_to_same_date_past_time_event" do
        future_assistance = FutureAssistance.create(user: users(:prueba2), event: events(:event9))
        assert_not future_assistance.persisted?
    end

    # PU40
    test "Create_future_assistance_but_already_exists" do
        future_assistance = FutureAssistance.create(user: users(:prueba2), event: events(:event5))
        assert future_assistance.persisted?
        future_assistance2 = FutureAssistance.create(user: users(:prueba2), event: events(:event5))
        assert_not future_assistance2.persisted?
    end

    # PU41
    test "Search_future_assistances_without_filters" do
        assistances = FutureAssistance.search_by(users(:prueba2))
        assert_equal 4, assistances.length
    end

    # PU42
    test "Search_future_assistances_by_event" do
        assistances = FutureAssistance.search_by(users(:prueba2), event_id: events(:event3).id)
        assert_equal 1, assistances.length
        assert_equal assistances[0].from, "Madrid"
    end

    # PU43
    test "Search_future_assistances_by_event_seat" do
        assistances = FutureAssistance.search_by(users(:prueba2), params: {event_seat: 1})
        assert_equal 1, assistances.length
        assert_equal assistances[0].from, "Asturias"
    end

    # PU44
    test "Search_future_assistances_by_from" do
        assistances = FutureAssistance.search_by(users(:prueba2), params: {from: "London"})
        assert_equal 1, assistances.length
        assert_equal assistances[0].from, "London"
    end    

    # PU45
    test "Search_future_assistances_by_company" do
        assistances = FutureAssistance.search_by(users(:prueba2), params: {company: 2})
        assert_equal 2, assistances.length
        assert_equal assistances[0].from, "Asturias"
        assert_equal assistances[1].from, "Italy"
    end    

    # PU46
    test "Search_future_assistances_with_filters" do
        assistances = FutureAssistance.search_by(users(:prueba2), params: {company: 1, from: "Madrid", event_seat: 0}, event_id: events(:event3).id)
        assert_equal 1, assistances.length
    end    

end
