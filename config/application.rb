require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LSGCOIs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.factory_bot.definition_file_paths = ["spec/factories"]

    config.before_configuration do
      # Add any additional conditions if needed
      if Rails.env.development? || Rails.env.test?
        # Clear session in development or test environment
        Rails.application.config.session_store :cookie_store, key: "_your_app_session"
      end
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
