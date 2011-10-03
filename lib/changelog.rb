require 'changelog/utils'
require 'changelog/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
require 'pivotal-tracker' if Changelog::Utils.gem_available?('pivotal-tracker')