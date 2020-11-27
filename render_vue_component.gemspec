$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "render_vue_component/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "render_vue_component"
  s.version     = RenderVueComponent::VERSION
  s.authors     = ["KevinLuo"]
  s.email       = ["kevin.luo@hey.com"]
  s.homepage    = "https://github.com/kevinluo201/render_vue_component"
  s.summary     = "Build html block and pass Props for mounting Vue component in Ruby on Rails"
  s.description = <<~END
    This gem only works in rails.
    It defines a helper method :render_vue_component which user can specify a Vue component name and parameters passed in.
    However, to mount Vue component, Javascript code is still required
  END
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.2.11.1"

  s.add_development_dependency "sqlite3"
end
