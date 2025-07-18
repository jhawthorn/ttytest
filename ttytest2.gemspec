# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttytest/version'

Gem::Specification.new do |spec|
  spec.name          = 'ttytest2'
  spec.version       = TTYtest::VERSION
  spec.authors       = ['Alex Eski']
  spec.email         = ['alexeski@gmail.com']

  spec.summary       = 'ttytest2 is an integration test framework for interactive console (tty) applications'
  spec.description   = 'ttytest2 runs shell/cli applications inside of tmux and allows you to make assertions on what the output should be'
  spec.homepage      = 'https://github.com/a-eski/ttytest2'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2.3'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'open3', '~> 0.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard', '~> 0.9'
end
