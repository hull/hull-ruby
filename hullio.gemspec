# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hull/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephane Bellity", "Hull"]
  gem.email         = ["stephane@hull.io"]
  gem.description   = %q{Hull Ruby Client}
  gem.summary       = %q{Hull Ruby Client}
  gem.homepage      = "http://hull.io"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "hullio"
  gem.require_paths = ["lib"]
  gem.version       = Hull::VERSION

  # Dependencies
  gem.add_dependency 'faraday', ['>= 0.7', '< 0.10']
  gem.add_dependency 'faraday_middleware', ['>= 0.7', '< 0.10']
  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_dependency 'mime-types', '~> 2.0'
  gem.add_dependency 'jwt', '~> 1.0'
  gem.add_dependency 'addressable', '~> 2.3'
  gem.add_dependency 'postrank-uri', '~> 1.0'

  # Development Dependencies
  gem.add_development_dependency 'activesupport', ['>= 2.3.9', '< 4']

end
