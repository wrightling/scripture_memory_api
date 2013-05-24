require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(:default, Rails.env)

module ScriptureMemoryApi
  class Application < Rails::Application
  end
end
