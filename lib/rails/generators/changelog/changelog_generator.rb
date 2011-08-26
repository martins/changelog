require 'rails/generators'
require 'rails/generators/migration'

class ChangelogGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def self.next_migration_number(dirname) #:nodoc:
      "%.3d" % (current_migration_number(dirname) + 1)
  end


  # Every method that is declared below will be automatically executed when the generator is run

  def copy_initializer_file
    copy_file 'pivotaltracker_initializer.rb', 'config/initializers/pivotaltracker.rb'
  end

  def create_migration_files
    self.class.migration_lookup_at(File.join(File.dirname(__FILE__),'../../../..','db/migrate')).each do |file|
      name = File.basename(file).gsub!(/\d+_/,'')
      begin
        migration_template File.expand_path(file), "db/migrate/#{name}"
      rescue Rails::Generators::Error => e
        puts "Migration #{name} already exists!"
      end
    end
  end

end
