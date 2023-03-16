# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/request_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-request-tracker'
  spec.version       = Rack::RequestTracker::VERSION
  spec.authors       = ['Julián Berbel Alt', 'Franco Bulgarelli']
  spec.email         = ['julian@mumuki.org', 'franco@mumuki.org']
  spec.summary       = 'Bunch of patches and rack middlewares to allow for transactional logs'
  spec.homepage      = 'http://github.com/mumuki/rack-request-tracker'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 5.1'
  spec.add_dependency 'request_store', '~> 1.4'
  spec.add_dependency 'mumukit-core', '~> 1.14'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
