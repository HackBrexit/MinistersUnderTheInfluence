require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Meetings
  class Application < Rails::Application
        config.generators do |g|
       g.template_engine :haml
       g.test_framework :rspec, :fixtures => true, :views => true
       g.fixture_replacement :factory_girl, :dir => "spec/factories"
       g.stylesheet_engine :sass
    end

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.i18n.available_locales = [:en, :de, :it, :fr]
    config.i18n.enforce_available_locales = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
