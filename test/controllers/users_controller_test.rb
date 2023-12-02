require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should redirect show to sign in if not authenticated" do
    get user_url users(:aaa)
    assert_response :redirect
  end

  test "should redirect index to sign in if not authenticated" do
    get users_url
    assert_response :redirect
  end
end
