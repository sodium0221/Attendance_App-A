require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sites_new_url
    assert_response :success
  end

end
