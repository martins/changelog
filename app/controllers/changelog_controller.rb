class ChangelogController < ApplicationController
  respond_to :html, :json
  def release_notes
    @relese_notes = Changelog::Release.get_release_notes
    respond_with @relese_notes
  end

  def current_release
    @current_release = Changelog::Release.get_current_release
    respond_with @current_release
  end

  def index
    @data = Changelog::Release.get_yaml_data
  end
end