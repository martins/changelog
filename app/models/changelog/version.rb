module Changelog
  class Version < ActiveRecord::Base
      has_many :pivotal_stories

      before_validation :generate_name

      default_scope order('release_date DESC, major DESC, minor DESC, build DESC')

      validates_numericality_of :major, :minor, :build, :only_integer => true
      validates_uniqueness_of :name

      def self.add_stories
        version_ids = self.used_version_ids
        empty_release_versions = (version_ids.present? ? Changelog::Version.where('id NOT IN (:version_ids)', {:version_ids => version_ids}) : Changelog::Version.all)
        empty_release_versions.each do |release_version|
          Changelog::PivotalStory.store_pivotal_stories(release_version.name, release_version.id)
        end
      end

      def self.rebuild_release_versions
        p "#{Changelog::PivotalStory.delete_all} deleted."
        Changelog::Version.add_stories
      end

      def self.latest
        version_ids = self.used_version_ids
        Changelog::Version.where('id IN (:version_ids)', {:version_ids => version_ids}).first if version_ids.present?
      end

      def self.with_stories
        version_ids = self.used_version_ids
        Changelog::Version.where('id IN (:version_ids)', {:version_ids => version_ids}) if version_ids.present?
      end

      def self.update_stories
        existing_stories_ids = Changelog::PivotalStory.select(:story_id).map(&:story_id)
        Changelog::Version.all.each do |release_version|
          Changelog::PivotalStory.store_pivotal_stories(release_version.name, release_version.id, existing_stories_ids)
        end
      end

      def self.parse_version(version, with_name = false)
        {
          :version => (with_name ? version.name : version.release_date),
          :pivotal_stories =>
          {
            :features => version.pivotal_stories.where(:story_type => 'feature'),
            :bugs => version.pivotal_stories.where(:story_type => 'bug')
          }
        }
      end

      private

      def generate_name
        self.name = "#{self.major}.#{self.minor}.#{self.build}"
      end

      def self.used_version_ids
        version_ids = Changelog::PivotalStory.select('version_id').map(&:version_id).uniq
      end
  end
end
# == Schema Information
#
# Table name: versions
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  major        :integer
#  minor        :integer
#  build        :integer
#  release_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

