require 'spec_helper'

describe "Release" do
  it "Should be able to return raw yaml data" do
    raw_data = Changelog::Release.get_raw_yaml_data
    raw_data.first.present?.should be_true
    raw_data.each{|version| version[:changelog_version].present?.should be_true }
    raw_data.count.should == 3
  end
  it "Should be able to return fromated data" do
    formated_data = Changelog::Release.get_formated_yaml_data
    formated_data.first.present?.should be_true
    formated_data.each do |version|
      version[:release_date].present?.should be_true
      version[:name].present?.should be_true
    end
    formated_data.count.should == 3
  end
  it "Should be able to return release notes" do
    release_notes = Changelog::Release.get_release_notes
    release_notes.count.should == 2
    version = release_notes.last
    version[:version].should == "2011-10-21"
    version[:user_stories][:features].count.should == 3
    version[:user_stories][:features].first[:body].should == 'Imlemented first feature.'
  end
  it "Should be able to return current release" do
    current_release = Changelog::Release.get_current_release
    current_release[:version].should == "2011-11-11"
    current_release[:user_stories][:features].first[:body].should == 'Implemented one feature for second release.'
    current_release[:user_stories][:bugs].first[:body].should == 'Fixed one bug for second release.'
  end
end