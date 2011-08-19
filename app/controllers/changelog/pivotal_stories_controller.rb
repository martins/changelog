class Changelog::PivotalStoriesController < ApplicationController
  def index
    version = (params[:version] && Changelog::Version.find(params[:version])) || Changelog::Version.latest
    @stories = version.pivotal_stories
    @possible_versions = Changelog::Version.with_stories.select('DISTINCT id, name')
    @selected_version = version && version.id
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