# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{changelog}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Martins Zakis}]
  s.date = %q{2011-08-26}
  s.email = %q{martins.zakis@tieto.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "app/controllers/changelog/pivotal_stories_controller.rb",
    "app/controllers/changelog/versions_controller.rb",
    "app/controllers/changelog_controller.rb",
    "app/models/changelog/pivotal_story.rb",
    "app/models/changelog/version.rb",
    "app/views/changelog/_release_version_details.html.erb",
    "app/views/changelog/current_release.html.erb",
    "app/views/changelog/pivotal_stories/index.html.erb",
    "app/views/changelog/release_notes.html.erb",
    "app/views/changelog/versions/_form.html.erb",
    "app/views/changelog/versions/edit.html.erb",
    "app/views/changelog/versions/index.html.erb",
    "app/views/changelog/versions/new.html.erb",
    "app/views/changelog/versions/show.html.erb",
    "config/initializers/changelog.rb",
    "config/routes.rb",
    "db/migrate/20110817132722_create_pivotal_stories.rb",
    "db/migrate/20110819065503_create_versions.rb",
    "db/migrate/20110819124434_add_accepted_at_to_pivotal_stories.rb",
    "lib/changelog.rb",
    "lib/engine.rb",
    "lib/rails/generators/changelog/changelog_generator.rb",
    "lib/tasks/pivotal_tracker.rake",
    "spec/factories.rb",
    "spec/models/version_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Gets stories from PivotalTracker and stores them for version management}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pivotal-tracker>, [">= 0"])
      s.add_development_dependency(%q<mongrel>, [">= 0"])
      s.add_development_dependency(%q<annotate>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.4"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<factory_girl_rails>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<pivotal-tracker>, [">= 0"])
      s.add_dependency(%q<mongrel>, [">= 0"])
      s.add_dependency(%q<annotate>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.4"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<factory_girl_rails>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<pivotal-tracker>, [">= 0"])
    s.add_dependency(%q<mongrel>, [">= 0"])
    s.add_dependency(%q<annotate>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.4"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<factory_girl_rails>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
