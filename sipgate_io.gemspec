$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sipgate_io/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sipgate_io"
  s.version     = SipgateIo::VERSION
  s.authors     = ["Chris Schmidt"]
  s.email       = ["chris@superbilk.org"]
  s.homepage    = "https://github.com/superbilk/sipgate_io"
  s.summary     = %q{Use sipgate.io with Rails}
  s.license     = "MIT"

  s.required_ruby_version = ['>= 2.2.0']

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "actionpack", "~> 4.2", ">= 4.2.5.1"
  s.add_dependency "activemodel", "~> 4.2", ">= 4.2.5.1"

  s.add_development_dependency "rails", "~> 4.2", ">= 4.2.5.1"
  s.add_development_dependency "sqlite3", "~> 1.3"
end
