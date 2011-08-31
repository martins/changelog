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
    self.class.migration_lookup_at(File.join(Changelog::Engine.root, 'db/migrate')).each do |file|
      name = File.basename(file).gsub!(/\d+_/,'')
      begin
        migration_template File.expand_path(file), "db/migrate/#{name}"
      rescue Rails::Generators::Error => e
        puts "   \e[1m\e[34midentical\e[0m  Migration #{name} already exists!"
      end
    end
  end

  def copy_test_files
     print "   \e[1m\e[34mquestion\e[0m   Do you want to copy test files for this gem to spec directory? They are written using rspec, capybara, factory_girl and database_cleaner. Copy files? [y/n] "
     begin
       answer = gets.chomp
     end while not answer =~ /[yn]/i
     if answer =~ /y/i
       copy_file File.join(Changelog::Engine.root,'spec/models/version_spec.rb'), 'spec/models/version_spec.rb'
       if File.exists?('spec/factories.rb')
         f = File.open('spec/factories.rb', 'r+')
         content = f.read
         if content.include?('Changelog::PivotalStory')
           puts "   \e[1m\e[34mexisting\e[0m   factories.rb already include Changelog::PivotalStory"
         else
           f2 = File.open(File.join(Changelog::Engine.root, 'spec/factories.rb'))
           addon = f2.read
           f2.close
           content << "\n" << addon
           f.write(content)
         end
         f.close
       else
         copy_file File.join(Changelog::Engine.root, 'spec/factories.rb'), 'spec/factories.rb'
       end
       copy_file File.join(Changelog::Engine.root, 'spec/spec_helper.rb'), 'spec/spec_helper.rb'
     end
   end

end
