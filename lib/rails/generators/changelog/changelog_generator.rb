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

  def copy_test_file
     print "   \e[1m\e[34mquestion\e[0m   Do you want to copy test files for this gem to spec directory? They are written using rspec. Copy files? [y/n] "
     begin
       answer = gets.chomp
     end while not answer =~ /[yn]/i
     if answer =~ /y/i
       copy_file File.join(Changelog::Engine.root,'spec/models/version_spec.rb'), 'spec/models/version_spec.rb'
     end
   end

end
