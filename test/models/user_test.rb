require "test_helper"

class UserTest < ActiveSupport::TestCase
  fixtures :all

  test "Create_users" do

    user1 = User.create!(username: "prueba", email: "prueba@gmail.com", password: "Prueba1!", role: roles(:user), description: "Amante de la música", ubication: ubications(:ubication1))
    assert user1.persisted?
    assert_equal user1.username, "prueba"
    assert_equal user1.email, "prueba@gmail.com"
    assert_equal user1.description, "Amante de la música"
    assert_equal user1.ubication.country.name, "Spain"
    assert_equal user1.ubication.city, "Oviedo"


    user2 = User.create(username: "prueba2", email: "prueba4@gmail.com", password: "Prueba1!", role: roles(:user))
    assert_not user2.persisted?

    user3 = User.create(username: "prueba4", email: "prueba3@gmail.com", password: "Prueba1!", role: roles(:user))
    assert_not user3.persisted?
  end

end
