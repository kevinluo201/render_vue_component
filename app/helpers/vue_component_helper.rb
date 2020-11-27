module VueComponentHelper
  def render_vue_component(component_name, params = {})
    content_tag(
      :div, 
      class: 'vue-component',
      data: {
        name: component_name,
        rails_data: params
      }.as_json,
    ) do
    end
  end
end