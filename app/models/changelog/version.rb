module Changelog
  class Version

    def self.validate_version_data(version_data, formated_data)
      return false unless (version_data['major'].present? && version_data['minor'].present? && version_data['build'].present?)
      return false if formated_data.detect{|version| (version[:name] == version_data['name'] && version[:id] != version_data['id'].to_i)}
      true
    end

    def self.latest(data)
      data.reject!{|version| (version.blank? || version[:pivotal_stories].blank?)}
      latest_version = data.map{|version| version[:release_date]}.sort.last
      data.detect{|version| version[:release_date] == latest_version}
    end

    def self.add_new_version(version_data, formated_changelog_data, raw_changelog_data)
      version_data['name'] = self.generate_name(version_data)
      version_data['id'] = self.generate_id(formated_changelog_data)
      version_data[:release_date] = self.generate_date(version_data)
      return false unless self.validate_version_data(version_data, formated_changelog_data)
      raw_changelog_data << {:changelog_version=>{
          :name => version_data['name'],
          :major => version_data['major'].to_i,
          :minor => version_data['minor'].to_i,
          :build => version_data['build'].to_i,
          :id => version_data['id'],
          :release_date => version_data['release_date'],
          :pivotal_stories => []
        }
      }
      Changelog::Release.write_yaml_file(raw_changelog_data)
    end

    def self.generate_name(version_data)
      "#{version_data[:major]}.#{version_data[:minor]}.#{version_data[:build]}"
    end

    def self.generate_date(version_data)
      Date.parse("#{version_data['date']['year']}-#{version_data['date']['month']}-#{version_data['date']['day']}").strftime('%Y-%m-%d')
    end

    def self.generate_id(formated_data)
      last_id = formated_data.map{|version| version[:id]}.sort.last
      if last_id
        last_id + 1
      else
        1
      end
    end

    def self.remove_version(version_id, raw_data)
      updated_data = raw_data.reject{|version| version[:changelog_version][:id] == version_id.to_i}.compact
      Changelog::Release.write_yaml_file(updated_data)
    end

    def self.update_version(version_data, formated_changelog_data, raw_data)
      version_data['name'] = self.generate_name(version_data)
      version_data[:release_date] = self.generate_date(version_data)
      return false unless self.validate_version_data(version_data, formated_changelog_data)
      updated_data = raw_data.map! do |version|
        if version[:changelog_version][:id] == version_data[:id].to_i
          {:changelog_version=>{
            :name => version_data['name'],
            :major => version_data['major'].to_i,
            :minor => version_data['minor'].to_i,
            :build => version_data['build'].to_i,
            :id => version[:changelog_version][:id],
            :release_date => version_data['release_date'],
            :pivotal_stories => (version[:changelog_version][:name]==version_data['name'] ? version[:changelog_version][:pivotal_stories] : [])
            }
          }
        else
          version
        end
      end
      Changelog::Release.write_yaml_file(updated_data)
    end

    def self.order_by_date(formated_data)
      formated_data.sort{|x, y| y[:release_date] <=> x[:release_date]}
    end

    def self.get_previous_version(formated_data)
      version_name = formated_data.map{|version| version[:name]}.sort.last
      formated_data.detect{|version| version[:name]==version_name}
    end

    def self.find_version_with_stories(version_id, formated_data)
      formated_data.detect{|version| (version[:id] == version_id.to_i && version[:pivotal_stories].present?)}
    end

    def self.get_possible_versions(formated_data)
      formated_data.reject!{|version| (version.blank? || version[:pivotal_stories].blank?)}
      formated_data.map{|version| [version[:name], version[:id]]}
    end

    private

    def self.used_version_ids
      version_ids = Changelog::PivotalStory.select('version_id').map(&:version_id).uniq
    end
  end
end
