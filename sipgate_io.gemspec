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
  s.description = %q{A Rails gem that makes it easier to use sipgate.io the Ruby way}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"

  s.add_development_dependency "sqlite3", "~> 1.3"
end
