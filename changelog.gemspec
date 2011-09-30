# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{changelog}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Martins Zakis}]
  s.date = %q{2011-09-30}
  s.email = %q{martins.zakis@tieto.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "README",
    "Rakefile",
    "VERSION",
    "app/controllers/changelog_controller.rb",
    "app/models/changelog/release.rb",
    "app/views/changelog/_release_version_details.html.erb",
    "app/views/changelog/current_release.html.erb",
    "app/views/changelog/release_notes.html.erb",
    "changelog.gemspec",
    "config/initializers/changelog.rb",
    "config/routes.rb",
    "lib/changelog.rb",
    "lib/engine.rb",
    "lib/rails/generators/changelog/changelog_generator.rb",
    "lib/rails/generators/changelog/templates/pivotaltracker_initializer.rb",
    "lib/tasks/.gitkeep",
    "lib/tasks/pivotal_tracker.rake"
  ]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Creates and stores changelog in yaml file. Allows to get stories from pivotal tracker.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pivotal-tracker>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<pivotal-tracker>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<pivotal-tracker>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

