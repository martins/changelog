module Changelog
  class UserStory

    def self.update_story(story_id, story_body, version_id, raw_data)
      raw_data.map! do |version|
        if version[:changelog_version][:id] == version_id
          version[:changelog_version][:user_stories].map! do |story|
            if story[:user_story][:story_id] == story_id
              story[:user_story][:body] = story_body
            end
            story
          end
        end
        version
      end
      Changelog::Release.write_yaml_file(raw_data)
    end

    def self.delete_user_story(story_id, version_id, raw_data)
      raw_data.map! do |version|
        if version[:changelog_version][:id] == version_id
          version[:changelog_version][:user_stories].reject! do |story|
            story[:user_story][:story_id] == story_id
          end.compact!
        end
        version
      end
      Changelog::Release.write_yaml_file(raw_data)
    end

  end
end
