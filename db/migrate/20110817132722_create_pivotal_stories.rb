class CreatePivotalStories < ActiveRecord::Migration
  def self.up
    create_table :pivotal_stories do |t|
       t.integer :version_id
       t.string :title
       t.string :story_type
       t.integer :story_id
      t.timestamps
    end
    add_index :pivotal_stories, [:version_id], :name => "pivotal_stories_n1"
  end

  def self.down
    drop_table :pivotal_stories
  end
end
