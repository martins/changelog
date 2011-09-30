require 'rails/generators'

class ChangelogGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end


  # Every method that is declared below will be automatically executed when the generator is run

  def copy_initializer_file
    copy_file 'pivotaltracker_initializer.rb', 'config/initializers/pivotaltracker.rb'
  end

end
