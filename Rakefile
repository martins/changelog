# Jeweler
begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "changelog"
    gem.summary = "Gets stories from PivotalTracker and stores them for version management"
    gem.email = "martins.zakis@tieto.com"
    gem.authors = ["Martins Zakis"]
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{db}/**/*", "{config}/**/*", "{spec}/**/*"]
    gem.files.include 'lib/rails/generators/changelog/templates/pivotaltracker_initializer.rb'
  end
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end
