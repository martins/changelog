class ChangelogController < ApplicationController
  respond_to :html, :json
  def release_notes
    versions = Changelog::Version.with_stories
    @relese_notes = []
    if versions.present?
      versions.each do |version|
        @relese_notes << Changelog::Version.parse_version(version)
      end
    end
    respond_with @relese_notes
  end
  def current_release
    version = Changelog::Version.latest
    @current_release = version && Changelog::Version.parse_version(version)
    respond_with @current_release
  end
end