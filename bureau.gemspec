# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bureau/version'

Gem::Specification.new do |spec|
  spec.name          = "bureau"
  spec.version       = Bureau::VERSION
  spec.authors       = ["Jan Owiesniak"]
  spec.email         = ["jo@neopoly.de"]
  spec.description   = %q{Bureau provide a simple interface to build custom xlsx files.}
  spec.summary       = %q{Bureau is based on axlsx.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "axlsx"
end
