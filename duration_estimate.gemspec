# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duration_estimate/version'

Gem::Specification.new do |spec|
  spec.name          = 'duration_estimate'
  spec.version       = DurationEstimate::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']

  spec.summary       = 'Do something to a collection of items and see how ' \
                       'long it is going to take. Useful for long-running ' \
                       'Rake tasks.'
  spec.homepage      = 'https://github.com/ollie/duration_estimate'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.10'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.10'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'rake',    '~> 10.4'
end
