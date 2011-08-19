class Changelog::Version < ActiveRecord::Base
end

# == Schema Information
#
# Table name: versions
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  major        :integer
#  minor        :integer
#  build        :integer
#  release_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

