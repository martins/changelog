class ChangelogController < ApplicationController
  respond_to :html, :json
  def release_notes
    versions = Changelog::Version.with_stories
    @relese_notes = []
    versions.each do |version|
      @relese_notes << parse_version(version)
    end
    respond_with @relese_notes
  end
  def current_release
    @current_release = parse_version(Changelog::Version.latest)
    respond_with @current_release
  end
  def parse_version(version)
    {:version => version, :pivotal_stories => version.pivotal_stories}
  end
end