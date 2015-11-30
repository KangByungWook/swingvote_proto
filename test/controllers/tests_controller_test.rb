require 'test_helper'

class TestsControllerTest < ActionController::TestCase
  test "should get scroll" do
    get :scroll
    assert_response :success
  end

end
