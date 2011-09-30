namespace :changelog do

  desc "Adds pivotal tracker stories to release versions with given label"
  task  :build, [:label] => :environment do |t, args|
    if args.label.present?
      p 'Adding stories..'
      Changelog::Release.build_version(args.label)
      p 'Task completed'
    else
      p 'No label provaided!'
    end
  end

  desc "Sets 'Unreleased' versions date value to current date."
  task :release => :environment do
    p 'Updating date..'
    Changelog::Release.update_release_date
    p 'Task completed'
  end

end
