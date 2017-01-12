require 'test_helper'

class Admin::YarnsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_yarns_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_yarns_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_yarns_edit_url
    assert_response :success
  end

  test "should get new" do
    get admin_yarns_new_url
    assert_response :success
  end

end
