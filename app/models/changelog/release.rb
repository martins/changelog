module Changelog
  class Release

    def self.get_raw_yaml_data
      file_name=File.join(Rails.root, "changelog.yml")
      content = File.exist?(file_name) && YAML.load_file(file_name)
      content ? content : []
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

    def self.get_release_notes
      data = self.order_by_date(self.get_formated_yaml_data)
      relese_notes = []
      data.each do |version|
        if version.present? && version[:user_stories].present?
          relese_notes << self.parse_version(version)
        end
      end
      relese_notes
    end

    def self.get_current_release
      data = self.get_formated_yaml_data
      data.reject!{|version| (version.blank? || version[:user_stories].blank?)}
      latest_version = data.map{|version| version[:release_date]}.sort.last
      version = data.detect{|version| version[:release_date] == latest_version}
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

    def self.order_by_date(formated_data)
      formated_data.sort{|x, y| y[:release_date] <=> x[:release_date]}
    end

    def self.build_version(label)
      data = self.get_raw_yaml_data
      project = ENV['PTR_PRID'] && PivotalTracker::Project.find(ENV['PTR_PRID'])
      if project
        stories = label.present? && project.stories.all(:story_type => ['feature', 'bug'], :label => label, :includedone => true)
        if stories.present?
          version = {:changelog_version => {
            :name => label,
            :release_date => 'Unreleased',
            :user_stories => []
          }}
          stories.each do |story|
            version[:changelog_version][:user_stories] << {:user_story=>{
              :body => story.name,
              :story_type => story.story_type
            }}
          end
          data << version
          puts "#{stories.count} added to version '#{label}'"
          self.write_yaml_file(data)
        else
          puts "No stories available with label '#{label}'"
        end
      else
        puts 'Unnable to retrieve project. Please check Project ID and Pivotaltracker Client token.'
      end
    end

    def self.update_release_date
      data = self.get_raw_yaml_data
      data.map! do |version|
        if version[:changelog_version].present? && version[:changelog_version][:release_date] == 'Unreleased'
          version[:changelog_version][:release_date] = Date.today.strftime('%Y-%m-%d')
        end
        version
      end
      self.write_yaml_file(data)
    end

    def self.write_yaml_file(data)
      puts 'Writting yaml..'
      FileUtils.touch(File.join(Rails.root, 'changelog.yml'))
      file = File.open(File.join(Rails.root, 'changelog.yml'), 'w')
      file.write(data.to_yaml)
      file.close
      true
    end

  end
end
