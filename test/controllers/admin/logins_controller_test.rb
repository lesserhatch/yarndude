require 'test_helper'

class Admin::LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_logins_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_logins_create_url
    assert_response :success
  end

end
