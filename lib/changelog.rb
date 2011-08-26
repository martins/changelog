module Changelog
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'pivotal-tracker'
end
