# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helmsman/version'

Gem::Specification.new do |spec|
  spec.name          = "helmsman"
  spec.version       = Helmsman::VERSION
  spec.authors       = ["Johannes Opper"]
  spec.email         = ["johannes.opper@gmail.com"]
  spec.description   = %q{Steers your navigation through the ocean of your application}
  spec.summary       = %q{Steers your navigation through the ocean of your application}
  spec.homepage      = "http://github.com/xijo/helmsman"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
