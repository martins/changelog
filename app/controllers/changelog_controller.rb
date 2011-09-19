class ChangelogController < ApplicationController
  respond_to :html, :json
  before_filter :load_yaml_data

  def release_notes
    @relese_notes = Changelog::Release.get_release_notes(@changelog_data)
    respond_with @relese_notes
  end

  def current_release
    @current_release = Changelog::Release.get_current_release(@changelog_data)
    respond_with @current_release
  end

  private

  def load_yaml_data
    @changelog_data = Changelog::Release.get_formated_yaml_data
  end

end