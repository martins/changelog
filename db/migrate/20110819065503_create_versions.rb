class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.string :name
      t.integer :major
      t.integer :minor
      t.integer :build
      t.date :release_date

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
