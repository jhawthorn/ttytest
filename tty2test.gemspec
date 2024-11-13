lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttytest/version'

Gem::Specification.new do |spec|
  spec.name          = 'ttytest2'
  spec.version       = TTYtest::VERSION
  spec.authors       = ['Alex Eski']
  spec.email         = ['alexeski@gmail.com']

  spec.summary       = 'ttytest2 is an integration test framework for interactive tty applications. Based on TTYtest!'
  spec.description   = 'ttytest2 allows running shell and/or cli applications inside of tmux and then making assertions on the output.'
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
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'yard'
end
