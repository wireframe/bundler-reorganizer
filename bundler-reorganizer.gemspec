# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler/reorganizer/version'

Gem::Specification.new do |spec|
  spec.name          = "bundler-reorganizer"
  spec.version       = Bundler::Reorganizer::VERSION
  spec.authors       = ["Ryan Sonnek"]
  spec.email         = ["ryan@codecrate.com"]
  spec.description   = %q{Reorganize your gemfile into sane groupings of gems}
  spec.summary       = %q{Cleanup your Gemfile by reordering gems into declarative groups}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
