module Changelog
  class PivotalStory < ActiveRecord::Base
    belongs_to :version

    def self.store_pivotal_stories(release_version_name, release_version_id)
      stories = PivotalTracker::Project.find(ENV['PTR_PRID']).stories.all(:story_type => ['feature', 'bug'], :current_state => 'accepted', :label => release_version_name)
      if stories.present?
        transaction do
          stories.each do |new_story|
            PivotalStory.new(
              :title => new_story.name,
              :story_type => new_story.story_type,
              :story_id => new_story.id,
              :version_id => release_version_id
            ).save
          end
        end
        p "#{stories.count} added to #{release_version_name} release version"
      end
    end
  end
end
# == Schema Information
#
# Table name: pivotal_stories
#
#  id         :integer         not null, primary key
#  version_id :integer
#  title      :string(255)
#  story_type :string(255)
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

