require 'test_helper'

class AjaxControllerTest < ActionController::TestCase
  test "should get get_images" do
    get :get_images
    assert_response :success
  end

  test "should get process_images" do
    get :process_images
    assert_response :success
  end

  test "should get process_captions" do
    get :process_captions
    assert_response :success
  end

end
