module Changelog
  class Release
    def self.get_yaml_data
      data = YAML.load_file(File.join(Rails.root, "changelog.yml"))
    end

    def self.get_release_notes
      data = self.get_yaml_data
      relese_notes = []
      data.each do |content|
        version = content[:changelog_version]
        if version.present? && version[:pivotal_stories].present?
          relese_notes << self.parse_version(version)
        end
      end
      relese_notes
    end

    def self.get_current_release
      data = self.get_yaml_data
      version = data.last && data.last[:changelog_version]
      self.parse_version(version) if version.present?
    end

    def self.parse_version(version)
      {
        :version => version[:release_date],
        :pivotal_stories =>
          {
            :features => version[:pivotal_stories].map{|s| s[:pivotal_story] if s[:pivotal_story][:story_type] == 'feature' }.compact,
            :bugs => version[:pivotal_stories].map{|s| s[:pivotal_story] if s[:pivotal_story][:story_type] == 'bug' }.compact
          }
      }
    end

    def self.build_version_stories(rebuild=false)
      data = self.get_yaml_data
      project = ENV['PTR_PRID'] && PivotalTracker::Project.find(ENV['PTR_PRID'])
      if project
        data.map do |content|
          version = content[:changelog_version]
          if version.present? && (rebuild || version[:pivotal_stories].empty?)
            version[:pivotal_stories]=[]
            stories = project.stories.all(:story_type => ['feature', 'bug'], :current_state => 'accepted', :label => version[:name], :includedone => true)
            if stories.present?
              stories.each do |new_story|
                version[:pivotal_stories]<<{:pivotal_story=>{
                  :title => new_story.name,
                  :story_type => new_story.story_type,
                  :story_id => new_story.id,
                  :accepted_at => new_story.accepted_at,
                  }
                }
              end
            end
          end
          {:changelog_version => version}
        end
      self.write_yaml_file(data.to_yaml)
      else
        p 'Unnable to retrieve project. Please check Project ID and Pivotaltracker Client token.'
      end
    end

    def self.write_yaml_file(data)
      p 'Writting yaml..'
      FileUtils.touch(File.join(Rails.root, 'changelog.yml'))
      file = File.open(File.join(Rails.root, 'changelog.yml'), 'w')
      file.write(data)
      file.close
      p 'Task completed'
    end

  end
end
