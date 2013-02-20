# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heathen/client/version'

Gem::Specification.new do |gem|
  gem.name          = "heathen-client"
  gem.version       = Heathen::Client::VERSION
  gem.authors       = [ "Peter Brindisi" ]
  gem.email         = [ "p.brindisi@ifad.org" ]
  gem.description   = %q{ A client for the Heathen server. Convert & download. }
  gem.summary       = %q{ A client for the Heathen server. }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = [ "lib" ]

  gem.add_dependency('yajl-ruby',   '~> 1.1.0')
  gem.add_dependency('rest-client', '~> 1.6.7')
end
