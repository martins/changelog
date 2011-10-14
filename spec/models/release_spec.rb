require 'spec_helper'

describe "Release" do
  context "with existing yaml file" do
    it "Should be able to return yaml data" do
      data = Changelog::Release.get_yaml_data
      data.present?.should be_true
      data.each{|version| version['version'].present?.should be_true }
      data.count.should == 3
    end
    it "Should be able to return release notes" do
      release_notes = Changelog::Release.get_release_notes
      release_notes.count.should == 2
      version = release_notes.last
      version['release_date'].should == "2011-10-21"
      version['features'].count.should == 3
      version['features'].first['body'].should == 'Imlemented first feature.'
    end
    it "Should be able to return current release" do
      current_release = Changelog::Release.get_current_release
      current_release['release_date'].should == "2011-11-11"
      current_release['features'].first['body'].should == 'Implemented one feature for second release.'
      current_release['bugs'].first['body'].should == 'Fixed one bug for second release.'
    end
  end
  context "with empty yaml file" do
    before(:all) do
      FileUtils.move(File.join(Rails.root,'changelog.yml'), File.join(Rails.root, 'changelog_hide.yml'))
      FileUtils.touch(File.join(Rails.root,'changelog.yml'))
    end
    it "Should not raise error when trying to get release notes" do
      release_notes = Changelog::Release.get_release_notes
      release_notes.should == []
    end
    it "Should not raise error when trying to get current release" do
      current_release = Changelog::Release.get_current_release
      current_release.should be_nil
    end
    after(:all) do
      FileUtils.move(File.join(Rails.root,'changelog_hide.yml'), File.join(Rails.root, 'changelog.yml'))
    end
  end
  context "without yaml file" do
    before(:all) do
      FileUtils.move(File.join(Rails.root,'changelog.yml'), File.join(Rails.root, 'changelog_hide.yml'))
    end
    it "Should not raise error when trying to get release notes" do
      release_notes = Changelog::Release.get_release_notes
      release_notes.should == []
    end
    it "Should not raise error when trying to get current release" do
      current_release = Changelog::Release.get_current_release
      current_release.should be_nil
    end
    after(:all) do
      FileUtils.move(File.join(Rails.root,'changelog_hide.yml'), File.join(Rails.root, 'changelog.yml'))
    end
  end
end