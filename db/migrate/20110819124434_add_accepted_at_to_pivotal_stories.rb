class AddAcceptedAtToPivotalStories < ActiveRecord::Migration
  def self.up
    add_column :pivotal_stories, :accepted_at, :date
  end

  def self.down
    remove_column :pivotal_stories, :accepted_at
  end
end
