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
      redirect_to :action => :index, :notice => 'Information updated', :version => params[:version]
    else
      render :action => :index
    end
  end
end