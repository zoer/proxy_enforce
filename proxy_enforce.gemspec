require File.expand_path('../lib/proxy_enforce/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yashchuk Oleg"]
  gem.email         = ["oazoer@gmail.com"]
  gem.description   = "A ruby gem that manage proxy servers."
  gem.summary       = "A ruby gem that manage proxy servers."
  gem.homepage      = "https://github.com/zoer/proxy_enforce"

  gem.files         = Dir["{lib,vendor}/**/*"] + ["README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "proxy_enforce"
  gem.require_paths = ["lib"]
  gem.version       = ProxyEnforce::VERSION
  gem.license       = "MIT"

  required_ruby_version = ">= 1.9.3"

  gem.add_dependency "hooks", ">= 0.4", "< 1.0"
end
