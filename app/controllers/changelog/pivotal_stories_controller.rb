class Changelog::PivotalStoriesController < ApplicationController
  def index
    version = (params[:version] && Changelog::Version.find(params[:version])) || Changelog::Version.latest
    if version
      @stories = version.pivotal_stories
      @possible_versions = Changelog::Version.with_stories.select('DISTINCT id, name')
      @selected_version = version.id
    else
      @stories = []
      @possible_versions = []
      @selected_version = nil
    end
  end

  def update
    @story = Changelog::PivotalStory.find(params[:id])
    if @story.update_attributes(:title => params[:title])
      redirect_to changelog_pivotal_stories_url(:version => params[:version]), :flash => {:notice => 'Story updated'}
    else
      render :action => :index
    end
  end

  def destroy
    @story = Changelog::PivotalStory.find(params[:id])
    @story.destroy
    redirect_to(changelog_pivotal_stories_url, :flash => {:notice => 'Story deleted'})
  end
end