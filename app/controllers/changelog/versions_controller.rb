class Changelog::VersionsController < ApplicationController
  # GET /changelog/versions
  # GET /changelog/versions.xml
  def index
    @changelog_versions = Changelog::Version.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @changelog_versions }
    end
  end

  # GET /changelog/versions/1
  # GET /changelog/versions/1.xml
  def show
    @changelog_version = Changelog::Version.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @changelog_version }
    end
  end

  # GET /changelog/versions/new
  # GET /changelog/versions/new.xml
  def new
    @changelog_version = Changelog::Version.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @changelog_version }
    end
  end

  # GET /changelog/versions/1/edit
  def edit
    @changelog_version = Changelog::Version.find(params[:id])
  end

  # POST /changelog/versions
  # POST /changelog/versions.xml
  def create
    @changelog_version = Changelog::Version.new(params[:changelog_version])

    respond_to do |format|
      if @changelog_version.save
        format.html { redirect_to(@changelog_version, :flash => {:notice => 'Version was successfully created.'}) }
        format.xml  { render :xml => @changelog_version, :status => :created, :location => @changelog_version }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @changelog_version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /changelog/versions/1
  # PUT /changelog/versions/1.xml
  def update
    @changelog_version = Changelog::Version.find(params[:id])

    respond_to do |format|
      if @changelog_version.update_attributes(params[:changelog_version])
        format.html { redirect_to(@changelog_version, :flash => {:notice => 'Version was successfully updated.'}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @changelog_version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /changelog/versions/1
  # DELETE /changelog/versions/1.xml
  def destroy
    @changelog_version = Changelog::Version.find(params[:id])
    @changelog_version.destroy

    respond_to do |format|
      format.html { redirect_to(changelog_versions_url) }
      format.xml  { head :ok }
    end
  end
end
