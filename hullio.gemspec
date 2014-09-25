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
  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'mime-types'
  gem.add_dependency 'jwt'
  gem.add_dependency 'addressable'
  gem.add_dependency 'postrank-uri'

  # Development Dependencies
  gem.add_development_dependency 'activesupport',       ['>= 2.3.9', '< 4']

end
