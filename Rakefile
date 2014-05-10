begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require File.expand_path('../config/application', __FILE__)

require 'rdoc/task'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run rubocop'
task :rubocop do
  sh('rubocop --format simple') { |ok, _| ok || abort }
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format documentation'
end

task default: [:spec, :rubocop]

Bundler::GemHelper.install_tasks
