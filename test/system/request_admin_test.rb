require "application_system_test_case"
include ActiveJob::TestHelper

class RequestAdminTest < ApplicationSystemTestCase
    fixtures :all

    def setup_admin
        TicketmasterService.stub :events_by, [] do
            visit "/users/sign_in" 
            fill_in "email_id", with: "admin@gmail.com"
            fill_in "password_id", with: "Prueba2!"
            click_on "Log in"
            assert_current_path "/", wait: 15
        end
    end

    test "PI75 - create_request_for_existing_artist" do
    end

end