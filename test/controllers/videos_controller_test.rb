require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  test "should get aws_signature" do
    get :aws_signature
    assert_response :success
  end

end
