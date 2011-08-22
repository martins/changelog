require 'spec_helper'

describe Changelog::Version do
  context "validation" do
    it "should generate correct name from version numbers" do
      version = Factory(:version)
      version.name.should == "#{version.major}.#{version.minor}.#{version.build}"
    end
    it "should NOT allow to save wrong version numbers" do
      version = Factory.build(:version, :minor => nil)
      version.valid?.should be_false
      version = Factory.build(:version, :major => 'asd')
      version.valid?.should be_false
    end
    it "should NOT allow to save versions with same name" do
      version1 = Factory(:version, :build => 9)
      version2 = Factory.build(:version, :build => 9)
      version2.valid?.should be_false
    end
  end
  context "stories" do
    before do
      @version=Factory(:version)
      3.times do
        Factory(:story, :version_id => @version.id)
      end
      Factory(:version, :release_date => Date.tomorrow)
    end
    it "should correctly return latest version" do
      Changelog::Version.latest.should == @version
    end
    it "should correctly return only versions with stories" do
      version_array=Changelog::Version.with_stories
      version_array.count.should == 1
      version_array[0].should == @version
    end
  end
end