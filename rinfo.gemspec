# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rinfo/version'

Gem::Specification.new do |gem|
  gem.name            = 'rinfo'
  gem.version         = Rinfo::VERSION
  gem.authors         = ['Rafe Colton']
  gem.email           = ['r.colton@modcloth.com']
  gem.homepage        = 'https://github.com/rafecolton/rinfo'
  gem.summary         = 'Generates an rinfo.json page for your Rails app'
  gem.description     = 'Generates an rinfo.json page for your Rails app'
  gem.license         = 'MIT'

  gem.files           = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables     = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.bindir          = 'bin'
  gem.test_files      = gem.files.grep(%r{^spec/})
  gem.require_paths   = ['lib']
  gem.required_ruby_version = '>= 1.9.3'

  # dev/test dependencies
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'sqlite3' unless RUBY_PLATFORM == 'java'

  # dev/test deps, no jruby
  gem.add_development_dependency 'pry' unless RUBY_PLATFORM == 'java'

  # full dependencies
  gem.add_dependency 'rails', '>= 3'
  gem.add_dependency 'git'
end
