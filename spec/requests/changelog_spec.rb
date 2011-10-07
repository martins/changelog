require 'spec_helper'

describe 'Changelog' do
  it "Should show current release" do
    visit '/changelog/current_release'
    page.should have_content('2011-11-11')
    page.should have_content('Implemented one feature for second release.')
    page.should have_content('Fixed one bug for second release.')
  end
  it "Should show release notes" do
    visit '/changelog/release_notes'
    page.should have_content('Release notes')
    page.should have_content('2011-11-11')
    page.should have_content('2011-10-21')
    page.should have_content('Fixed one bug for second release.')
    page.should have_content('Imlemented first feature.')
  end
end