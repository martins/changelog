module Changelog
  class Release

    def self.get_raw_yaml_data
      file_name=File.join(Rails.root, "changelog.yml")
      if File.exist?(file_name)
        content = YAML.load_file(file_name)
        self.parse_content(content)
      else
        []
      end
    end

    def self.get_formated_yaml_data
      raw_data = self.get_raw_yaml_data
      raw_data.map! do |version|
        version[:changelog_version]
      end
      raw_data.each do |version|
        version[:user_stories].map!{|story| story[:user_story]} if version[:user_stories].present?
      end
    end

    def self.parse_content(content)
      v_seq = 0
      content.map! do |version|
        if version[:changelog_version]
          v_seq += 1
          version[:changelog_version][:id] = v_seq
          complex_name = version[:changelog_version][:name].split('.')
          version[:changelog_version][:build]=complex_name.pop
          version[:changelog_version][:minor]=complex_name.pop
          version[:changelog_version][:major]=complex_name.pop
          s_seq = 0
          version[:changelog_version][:user_stories].map! do |story|
            if story[:user_story]
              s_seq += 1
              story[:user_story][:story_id] = s_seq
            end
            story
          end if version[:changelog_version][:user_stories].present?
        end
        version
      end.compact
    end

    def self.get_release_notes(data)
      relese_notes = []
      data.each do |version|
        if version.present? && version[:user_stories].present?
          relese_notes << self.parse_version(version)
        end
      end
      relese_notes
    end

    def self.get_current_release(data)
      version = Changelog::Version.latest(data)
      self.parse_version(version) if version.present?
    end

    def self.parse_version(version)
      {
        :version => version[:release_date],
        :user_stories =>
          {
            :features => version[:user_stories].map{|story| story if story[:story_type] == 'feature' }.compact,
            :bugs => version[:user_stories].map{|story| story if story[:story_type] == 'bug' }.compact
          }
      }
    end

    def self.build_version_stories(rebuild=false)
      data = self.get_raw_yaml_data
      project = ENV['PTR_PRID'] && PivotalTracker::Project.find(ENV['PTR_PRID'])
      if project
        data.map! do |content|
          version = content[:changelog_version]
          if version.present? && (rebuild || (version[:user_stories] && version[:user_stories].empty?))
            version[:user_stories]=[]
            stories = project.stories.all(:story_type => ['feature', 'bug'], :current_state => 'accepted', :label => version[:name], :includedone => true)
            if stories.present?
              stories.each do |new_story|
                version[:user_stories]<<{:user_story=>{
                  :body => new_story.name,
                  :story_type => new_story.story_type,
                  :accepted_at => new_story.accepted_at.strftime('%Y-%m-%d')
                  }
                }
              end
            p "#{stories.count} added to version #{version[:name]}"
            end
          end
          {:changelog_version => version}
        end
      self.write_yaml_file(data)
      else
        p 'Unnable to retrieve project. Please check Project ID and Pivotaltracker Client token.'
      end
    end

    def self.write_yaml_file(data)
      p 'Writting yaml..'
      FileUtils.touch(File.join(Rails.root, 'changelog.yml'))
      file = File.open(File.join(Rails.root, 'changelog.yml'), 'w')
      parsed_data = self.remove_temporary_data(data)
      file.write(parsed_data.to_yaml)
      file.close
      true
    end

    def self.remove_temporary_data(data)
      data.map! do |version|
        version[:changelog_version].delete(:id)
        version[:changelog_version].delete(:major)
        version[:changelog_version].delete(:minor)
        version[:changelog_version].delete(:build)
        version[:changelog_version][:user_stories].map! do |story|
          story[:user_story].delete(:story_id)
          story
        end if version[:changelog_version][:user_stories].present?
        version
      end
    end

  end
end
