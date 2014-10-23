require File.expand_path('../boot', __FILE__)

require "rails"
#require "rails/all"

%w(
  neo4j
	action_controller
  action_mailer
  sprockets
).each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)
Bundler.require(:default, Rails.env)

module Gsn
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable Neo4j generators, e.g:  rails generate model Admin --parent User
    config.generators do |g|
      g.orm             :neo4j
      g.test_framework  :rspec, fixture: false
    end

    config.neo4j.storage_path = "/home/pdipietro/gsn/neo4j/data/graph.db"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = true

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.js)

    config.assets.paths << Rails.root.join("lib","assets","bower_components","bootstrap-sass-official", "assets", "stylesheets")
    config.assets.paths << Rails.root.join("lib","assets","bower_components","bootstrap-sass-official", "assets","fonts")
  end
end
