require 'spec_helper'

describe Changelog::Version do
  before do
    @raw_data = [
      {:changelog_version =>
        {:user_stories => [
          {:user_story => {:accepted_at => "2011-08-18", :story_type => "bug", :title => "User can get infinite ammount of money and stuff."}},
          {:user_story => {:accepted_at => "2011-08-19", :story_type => "feature", :title => "user should see current2."}}],
        :release_date => "2011-09-10", :name => "0.5.9"}},
      {:changelog_version =>
        {:user_stories => [{:user_story => {:accepted_at => "2011-08-25", :story_type => "feature", :title => "user should be able to see tasks"}}],
        :release_date => "2011-09-21", :name => "1.1.0"}},
      {:changelog_version => {:user_stories => [], :release_date => "2011-11-19", :name => "1.1.1"}}]

  end
  it "should correctly format raw input data" do
    formated_data=Changelog::Release.parse_content(@raw_data)
    formated_data.count.should == @raw_data.count
    formated_version = formated_data.first[:changelog_version]
    formated_version[:id].should == 1
    formated_version[:major].should == '0'
    formated_version[:minor].should == '5'
    formated_version[:build].should == '9'
    formated_version[:user_stories].first[:user_story][:story_id].should == 1
  end
  it "should remove temporary data before saving to data to yaml" do
    parsed_data = Changelog::Release.remove_temporary_data(@raw_data)
    parsed_data.count.should == @raw_data.count
    parsed_version = parsed_data.first[:changelog_version]
    parsed_version[:id].should be_nil
    parsed_version[:major].should be_nil
    parsed_version[:user_stories].first[:user_story][:story_id].should be_nil
  end
end