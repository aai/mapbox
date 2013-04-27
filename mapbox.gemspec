# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mapbox/version'

Gem::Specification.new do |spec|
  spec.name          = "mapbox"
  spec.version       = Mapbox::VERSION
  spec.authors       = ["Mark Madsen"]
  spec.email         = ["growl@agileanimal.com"]
  spec.description   = %q{Ruby Gem for the MapBox Static Image API}
  spec.summary       = %q{Ruby Gem for the MapBox Static Image API}
  spec.homepage      = "https://github.com/aai/mapbox"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.9'
end
