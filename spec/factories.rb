Factory.define :version, {:class => Changelog::Version} do |f|
  f.major 0
  f.minor 5
  f.sequence(:build)
  f.release_date Date.today
end

Factory.define :story, {:class => Changelog::PivotalStory} do |f|
  f.title "User should be able to see pivotal stories."
  f.story_type 'feature'
  f.sequence(:story_id)
  f.accepted_at Date.yesterday
  f.association :version
end