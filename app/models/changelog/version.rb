module Changelog
  class Version < ActiveRecord::Base
      has_many :pivotal_stories
      default_scope order('release_date DESC, major DESC, minor DESC, build DESC')
      validates_presence_of :major, :minor, :build
      before_save :generate_name

      def self.add_stories
        version_ids = Changelog::PivotalStory.select('DISTINCT version_id').map(&:version_id)
        empty_release_versions = (version_ids.present? ? Changelog::Version.where('id NOT IN (:version_ids)', {:version_ids => version_ids}) : Changelog::Version.all)
        empty_release_versions.each do |release_version|
          Changelog::PivotalStory.store_pivotal_stories(release_version.name, release_version.id)
        end
      end

      def self.rebuild_release_versions
        p "#{Changelog::PivotalStory.delete_all} deleted."
        Changelog::Version.add_stories
      end

      private

      def generate_name
        self.name = "#{self.major}.#{self.minor}.#{self.build}"
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

