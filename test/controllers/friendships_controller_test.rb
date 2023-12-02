require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index to sign in if not authenticated" do
    get user_friends_url users(:aaa)
    assert_response :redirect
  end

  test "should redirect create to sign in if not authenticated" do
    post friendships_url
    assert_response :redirect
  end

  test "should redirect update to sign in if not authenticated" do
    put friendship_url users(:aaa)
    assert_response :redirect
  end

  test "should redirect destroy to sign in if not authenticated" do
    delete friendship_url users(:aaa)
    assert_response :redirect
  end
end
