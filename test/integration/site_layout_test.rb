require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'home layout test' do
    get root_path
    assert_template 'static_pages/home'
  end

end
