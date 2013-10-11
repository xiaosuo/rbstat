# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbstat/version'

Gem::Specification.new do |gem|
  gem.name          = "rbstat"
  gem.version       = Rbstat::VERSION
  gem.authors       = ["Changli Gao"]
  gem.email         = ["xiaosuo@gmail.com"]
  gem.description   = %q{A statistics daemon}
  gem.summary       = %q{A statistics daemon in Ruby}
  gem.homepage      = "https://github.com/xiaosuo/rbstat"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'
  gem.add_development_dependency 'rake'
end
