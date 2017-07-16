Dir[File.expand_path "lib/**/*.rb"].each {|f| require(f) }
require 'active_support/all'
require 'rest_client'
