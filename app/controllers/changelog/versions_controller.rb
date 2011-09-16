class Changelog::VersionsController < ApplicationController
  before_filter :load_yaml_data

  def index
    @changelog_versions = Changelog::Version.order_by_date(@changelog_data_formated)
  end

  def new
    @date = Date.today
    @method = 'post'
    previous_version = Changelog::Version.get_previous_version(@changelog_data_formated)
    params[:major]=previous_version[:major]
    params[:minor]=previous_version[:minor]
    params[:build]=(previous_version[:build].to_i+1)
  end

  def edit
    @date = Date.parse(params[:release_date])
    @method = 'put'
    @id = params[:id]
  end

  def create
    version_data = params[:changelog_version]
    version_data[:date] = params[:date]
    if Changelog::Version.add_new_version(version_data, @changelog_data_formated, @changelog_data_raw)
      redirect_to(changelog_versions_url, :flash => {:notice => 'Version was successfully created.'})
    else
      @method = 'post'
      @date = Date.parse(Changelog::Version.generate_date(version_data))
      flash.now[:error] = 'Not all data is correct. Please check, that all values are entered and that name is unique!'
      render :action => 'new'
    end
  end

  def update
    version_data = params[:changelog_version]
    version_data[:id] = params[:id]
    version_data[:date] = params[:date]
    if Changelog::Version.update_version(version_data, @changelog_data_formated, @changelog_data_raw)
      flash[:notice] = 'Version was successfully updated.'
      redirect_to changelog_versions_url
    else
      @method = 'put'
      @date = Date.parse(Changelog::Version.generate_date(version_data))
      @id = params[:id]
      flash[:error] = 'Not all data is correct. Please check, that all values are entered and that name is unique!'
      render :action => 'edit'
    end
  end

  def destroy
    version_id = params[:id]
    if Changelog::Version.remove_version(version_id, @changelog_data_raw)
      flash[:notice] = 'Version has been deleted'
    else
      flash[:error] = 'Unexpected error while deleting version'
    end
    redirect_to(changelog_versions_url)
  end

  private

  def load_yaml_data
    @changelog_data_raw = Changelog::Release.get_raw_yaml_data
    @changelog_data_formated = Changelog::Release.get_formated_yaml_data
  end
end
