# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'completeness/version'

Gem::Specification.new do |spec|
  spec.name          = "completeness"
  spec.version       = Completeness::VERSION
  spec.authors       = ["undr"]
  spec.email         = ["undr@yandex.ru"]
  spec.description   = %q{Completeness is a way to add completeness progress (like in LinkedIn) into your application.}
  spec.summary       = %q{Completeness is a way to add completeness progress (like in LinkedIn) into your application.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
