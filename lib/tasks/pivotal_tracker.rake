namespace :changelog do

  desc "Adds pivotal tracker stories to empty release versions"
  task  :build => :environment do
    p 'Adding stories..'
    Changelog::Release.build_version_stories
    p 'Task completed'
  end

  desc "Clears changelog data bases and repopulates it with data"
  task :rebuild => :environment do
    Changelog::Release.build_version_stories(true)
    p 'Task completed'
  end

  desc 'Checks each release version for unsaved stories'
  task :update => :environment do
    Changelog::Release.build_version_stories(false, true)
    p 'Task completed'
  end

end
