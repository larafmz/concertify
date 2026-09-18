require "test_helper"

class RegisterTest < ActiveSupport::TestCase
  fixtures :all

  test "Create_registers" do

    # PU25
    register1 = Register.create(user: users(:prueba2), event: events(:event3), review: "Muy chulo", rating: 5)
    assert register1.persisted?
    assert_equal register1.review, "Muy chulo"
    assert_equal register1.type, "Register"
    assert_equal register1.rating, 5

    # PU26
    register2 = Register.create(user: users(:prueba2), event: events(:event8))
    assert_not register2.persisted?

    # PU27
    register3 = Register.create(user: users(:prueba2), event: events(:event5))
    assert_not register3.persisted?

    # PU28
    register4 = Register.create(user: users(:prueba2), event: events(:event4))
    assert_not register4.persisted?

    # PU29
    register5 = Register.create(user: users(:prueba2), event: events(:event9))
    assert register5.persisted?

  end

end
