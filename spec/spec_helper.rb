# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'factory_girl'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
end

def without_timestamping_of(*klasses)
  if block_given?
    klasses.delete_if { |klass| !klass.record_timestamps }
    klasses.each { |klass| klass.record_timestamps = false }
    begin
      yield
    ensure
      klasses.each { |klass| klass.record_timestamps = true }
    end
  end
end

def version(version_num)
  {'HTTP_ACCEPT' => "application/smapi.v#{version_num}+json"}
end
