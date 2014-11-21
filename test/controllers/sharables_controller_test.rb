require 'test_helper'

class SharablesControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get :new
    assert_redirected_to login_url
  end

  test "should get index" do
    get :index
    assert_redirected_to login_url
  end

end
