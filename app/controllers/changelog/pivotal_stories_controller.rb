class Changelog::PivotalStoriesController < ApplicationController
  before_filter :load_yaml_data

  def index
    version = (params[:version] && Changelog::Version.find_version_with_stories(params[:version], @changelog_data_formated)) || Changelog::Version.latest(@changelog_data_formated)
    if version.present?
      @stories = version[:pivotal_stories]
      @possible_versions = Changelog::Version.get_possible_versions(@changelog_data_formated)
      @selected_version = version[:id]
    else
      @stories = []
      @possible_versions = []
      @selected_version = nil
    end
  end

  def update
    if Changelog::PivotalStory.update_story(params[:id].to_i, params[:title], params[:version].to_i, @changelog_data_raw)
      flash[:notice] = 'Story updated'
    else
      flash[:error] = 'Unexpected error while updating pivotal story.'
    end
    redirect_to changelog_pivotal_stories_url(:version => params[:version])
  end

  def destroy
    if Changelog::PivotalStory.delete_pivotal_story(params[:id].to_i, params[:version].to_i, @changelog_data_raw)
      flash[:notice] = 'Story deleted'
    else
      flash[:error] = 'Unexpected error while deleting pivotal story!'
    end
    redirect_to changelog_pivotal_stories_url(:version => params[:version])
  end

  private

  def load_yaml_data
    @changelog_data_raw = Changelog::Release.get_raw_yaml_data
    @changelog_data_formated = Changelog::Release.get_formated_yaml_data
  end
end