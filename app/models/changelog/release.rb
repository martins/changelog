module Changelog
  class Release

    def self.get_yaml_data
      file_name=File.join(Rails.root, "changelog.yml")
      content = File.exist?(file_name) && YAML.load_file(file_name)
      (content && content['changelog']) ? content['changelog'] : []
    end

    def self.get_release_notes
      data = self.order_by_date(self.get_yaml_data)
      data.map{|version| version if (version.present? && (version['features'].present? || version['bugs'].present?))}.compact
    end

    def self.get_current_release
      self.get_release_notes.first
    end

    def self.order_by_date(data)
      data.sort{|x, y| y['release_date'] <=> x['release_date']}
    end

    def self.build_version(label)
      project = ENV['PTR_PRID'] && PivotalTracker::Project.find(ENV['PTR_PRID'])
      if project
        stories = label.present? && project.stories.all(:story_type => ['feature', 'bug'], :label => label, :includedone => true)
        if stories.present?
          version = {
            'version' => label,
            'release_date' => 'Unreleased',
            'features' => [],
            'bugs' => []
          }
          stories.each do |story|
            version["#{story.story_type}s"] << {'body' => story.name}
          end
          puts "#{stories.count} added to version '#{label}'"
          self.add_version_to_yaml(version)
        else
          puts "No stories available with label '#{label}'"
        end
      else
        puts 'Unnable to retrieve project. Please check Project ID and Pivotaltracker Client token.'
      end
    end

    def self.update_release_date
      if File.exists?(File.join(Rails.root, 'changelog.yml'))
        content=""
        File.open(File.join(Rails.root, 'changelog.yml'), 'r'){|file| content = file.read }
        if content.gsub!(/release_date: '[a-zA-Z]{10}'/, "release_date: '#{Date.today.strftime('%Y-%m-%d')}'")
          puts 'Writting yaml..'
          File.open(File.join(Rails.root,'tmp/~changelog.yml'), 'w'){|file| file.write(content)}
          FileUtils.move(File.join(Rails.root,'tmp/~changelog.yml'), File.join(Rails.root, 'changelog.yml'))
        else
          puts 'Nothing to update.'
        end
      else
        puts "Couldn't find changelog.yml file!"
      end
      true
    end

    def self.add_version_to_yaml(version)
      puts 'Writting yaml..'
      File.open(File.join(Rails.root, 'changelog.yml'), 'a') do |file|
        file << "  - version: #{version['version']}\n"
        file << "    release_date: '#{version['release_date']}'\n"
        ['features','bugs'].each do |type|
          if version[type].present?
            file << "    #{type}:\n"
            version[type].each{|story| file << "      - body: '#{story['body']}'\n"}
          else
            file << "    #{type}: []\n"
          end
        end
      end
      true
    end

  end
end
