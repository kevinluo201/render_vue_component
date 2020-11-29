require 'test_helper'

class VueComponentHelperTest < ActionView::TestCase
  include VueComponentHelper
  test "should return" do
    dom = render_vue_component('BaseComponent', text: 'abc')
    html_escaped_json = CGI::escapeHTML('{"text":"abc"}')
    assert_dom_equal(
      %{<div class="vue-component" data-name="BaseComponent" data-rails-data="#{html_escaped_json}"></div>},
      dom
    )
  end
end