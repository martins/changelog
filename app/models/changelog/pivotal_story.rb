module Changelog
  class PivotalStory < ActiveRecord::Base
    belongs_to :version
    default_scope order('story_type, accepted_at DESC, title')

    def self.store_pivotal_stories(release_version_name, release_version_id, existing_stories_ids = false)
      project = ENV['PTR_PRID'] && PivotalTracker::Project.find(ENV['PTR_PRID'])
      if project
        stories = project.stories.all(:story_type => ['feature', 'bug'], :current_state => 'accepted', :label => release_version_name, :includedone => true)
        if existing_stories_ids.present? && stories.present?
          stories.reject!{|story| existing_stories_ids.include?(story.id)}.compact!
        end
        if stories.present?
          transaction do
            stories.each do |new_story|
              PivotalStory.new(
                :title => new_story.name,
                :story_type => new_story.story_type,
                :story_id => new_story.id,
                :accepted_at => new_story.accepted_at,
                :version_id => release_version_id
              ).save
            end
          end
          p "#{stories.count} added to #{release_version_name} release version"
        end
      else
        p 'Unnable to retrieve project. Please check Project ID and Pivotaltracker Client token.'
      end
    end
  end
end
# == Schema Information
#
# Table name: pivotal_stories
#
#  id          :integer         not null, primary key
#  version_id  :integer
#  title       :string(255)
#  story_type  :string(255)
#  story_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  accepted_at :date
