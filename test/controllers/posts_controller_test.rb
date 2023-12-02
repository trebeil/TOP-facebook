require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect get index to sign in if not authenticated" do
    get posts_url
    assert_response :redirect
  end
end
