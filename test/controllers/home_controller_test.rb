require "test_helper"
require "minitest/mock"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    TicketmasterService.stub(:events_by, []) do
      get home_index_url
    end

    assert_response :success
  end
end