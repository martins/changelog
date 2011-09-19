module Changelog
  class PivotalStory

    def self.update_story(story_id, story_body, version_id, raw_data)
      raw_data.map! do |version|
        if version[:changelog_version][:id] == version_id
          version[:changelog_version][:pivotal_stories].map! do |story|
            if story[:pivotal_story][:story_id] == story_id
              story[:pivotal_story][:title] = story_body
            end
            story
          end
        end
        version
      end
      Changelog::Release.write_yaml_file(raw_data)
    end

    def self.delete_pivotal_story(story_id, version_id, raw_data)
      raw_data.map! do |version|
        if version[:changelog_version][:id] == version_id
          version[:changelog_version][:pivotal_stories].reject! do |story|
            story[:pivotal_story][:story_id] == story_id
          end.compact!
        end
        version
      end
      Changelog::Release.write_yaml_file(raw_data)
    end

  end
end
