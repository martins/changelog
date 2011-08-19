namespace :changelog do

  desc "Adds pivotal tracker stories to empty release versions"
  task  :build => :environment do
    Changelog::Version.add_stories
    p 'Task completed'
  end

  desc "Clears changelog data bases and repopulates it with data"
  task :rebuild => :environment do
    Changelog::Version.rebuild_release_versions
    p 'Task completed'
  end

end
