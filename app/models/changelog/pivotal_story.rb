module Changelog
  class PivotalStory < ActiveRecord::Base
    def self.retrieve_pivotal_stories
      stored_id = PivotalStory.select(:story_id).map(&:story_id)
      # stories = PivotalTracker::Project.find(351663).stories.find(:story_type => ['feature', 'bug'], :current_state => 'accepted')
      stories = PivotalTracker::Project.find(ENV['PTR_PRID']).stories.all
      stories.reject{|story| stored_id.include?(story.id)}.compact if stories.present?
    end

    def self.store_new_pivotal_stories(release_version)
      new_stories = PivotalStory.retrieve_pivotal_stories
      if new_stories.present?
        transaction do
          new_stories.each do |new_story|
            PivotalStory.new(
              :title => new_story.name,
              :story_type => new_story.story_type,
              :story_id => new_story.id
            ).save
          end
        end
        new_stories.count
      else
        0
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

