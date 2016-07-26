require 'test_helper'

class SeatingControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get seating_show_url
    assert_response :success
  end

  test "should get edit" do
    get seating_edit_url
    assert_response :success
  end

  test "should get update" do
    get seating_update_url
    assert_response :success
  end

end
