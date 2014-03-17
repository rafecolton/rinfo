# coding: utf-8

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$TOP = File.expand_path('..', __FILE__)

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

  gem.files           = `git ls-files`.split($/)
  gem.executables     = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.bindir          = 'bin'
  gem.test_files      = gem.files.grep(%r{^spec/})
  gem.require_paths   = ['lib']
  gem.required_ruby_version = '>= 1.9.3'

  %w(rake rspec rubocop).map{ |g| gem.add_development_dependency g }
  gem.add_development_dependency 'pry' unless RUBY_PLATFORM == 'java'

  gem.add_dependency 'rails', '~> 4.0.4'
  gem.add_dependency 'git'
end
