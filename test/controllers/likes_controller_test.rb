require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "should not get index" do
    get likes_url
    assert_response :not_found
  end

  test "should redirect create to sign in if not authenticated" do
    post likes_url
    assert_response :redirect
  end

  test "should redirect destroy to sign in if not authenticated" do
    delete like_url likes(:one)
    assert_response :redirect
  end
end
