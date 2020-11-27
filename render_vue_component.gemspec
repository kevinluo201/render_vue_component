$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "render_vue_component/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "render_vue_component"
  s.version     = RenderVueComponent::VERSION
  s.authors     = ["KevinLuo"]
  s.email       = ["kevin.luo@hey.com"]
  s.homepage    = "https://tw.yahoo.com"
  s.summary     = "summary"
  s.description = "desc"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.2.11.1"

  s.add_development_dependency "sqlite3"
end
