class PivotalStoriesController < ApplicationController
  def index
    @stories = Changelog::PivotalStory.all
  end

  def edit
    @story = Changelog::PivotalStory.find(params[:id])
  end

  def new
    Changelog::PivotalStory.store_new_pivotal_stories('')
    redirect_to :action => :index
  end

  def update
    @story = Changelog::PivotalStory.find(params[:id])
    p params
    if @story.update_attributes(params[:pivotal_story])
      redirect_to :action => :index, :notice => 'Information updated'
    else
      render :action => 'edit'
    end
  end
end