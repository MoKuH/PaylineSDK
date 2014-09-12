# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payline_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "payline_sdk"
  spec.version       = PaylineSDK::VERSION
  spec.authors       = ["Sébastien Loyer"]
  spec.email         = ["loyer.sebastien@gmail.com"]
  spec.summary       = %q{SDK for Payline API}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/Sbastien/payline_sdk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'savon', '~> 2.3.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
