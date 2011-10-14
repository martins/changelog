require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# Jeweler
begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "changelog"
    gem.summary = "Creates and stores changelog in yaml file. Allows to get stories from pivotal tracker."
    gem.email = "martins.zakis@tieto.com"
    gem.authors = ["Martins Zakis"]
    gem.files.exclude 'Gemfile.lock'
    gem.files.exclude 'spec/*'
    gem.files.exclude 'spec/*/*'
    gem.files.exclude 'spec/*/*/*'
    gem.files.exclude 'spec/*/*/*/*'
    gem.files.exclude 'spec/*/*/*/*/*'
  end
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end
