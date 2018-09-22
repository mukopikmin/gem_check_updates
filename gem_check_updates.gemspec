# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_check_updates/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_check_updates'
  spec.version       = GemCheckUpdates::VERSION
  spec.authors       = ['Yusuke Mukai']
  spec.email         = ['mukopikmin@gmail.com']

  spec.summary       = 'Automatically update Gemfile'
  spec.description   = 'Automatically update and overwrite version of gems in Gemfile'
  spec.homepage      = 'https://github.com/mukopikmin/gem_check_updates'
  spec.licenses      = ['MIT']

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16.5'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.8'
  spec.add_development_dependency 'rake', '~> 12.3.1'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.1'
  spec.add_development_dependency 'webmock', '~> 3.4.2'

  spec.add_dependency 'colored', '~> 1.2'
  spec.add_dependency 'rest-client', '~> 2.0'
end
