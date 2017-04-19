require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestHeroku
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # to be decided later
        origins 'localhost:8000', 'localhost:4200', 'atratobris.github.io'
        resource '*', headers: :any, methods: [:post, :options, :put, :delete]
      end
    end

  end
end
