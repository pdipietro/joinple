# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( social/gsn_bootstrap.css )
Rails.application.config.assets.precompile += %w( social/trace_bootstrap.css )
Rails.application.config.assets.precompile += %w( social/work_bootstrap.css )

Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-regular.eot )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-regular.svg )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-regular.ttf )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-regular.woff )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-regular.woff2 )

Rails.application.config.assets.precompile += %w( ./../fonts/FontAwesome.otf )
Rails.application.config.assets.precompile += %w( ./../fonts/fontawesome-webfont.eot )
Rails.application.config.assets.precompile += %w( ./../fonts/fontawesome-webfont.svg )
Rails.application.config.assets.precompile += %w( ./../fonts/fontawesome-webfont.ttf )
Rails.application.config.assets.precompile += %w( ./../fonts/fontawesome-webfont.woff )

Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-halfling.ttf )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-halfling.woff )
Rails.application.config.assets.precompile += %w( ./../fonts/glyphicons-halfling.woff2 )

Rails.application.config.assets.precompile += %w( glyphicons.css )
Rails.application.config.assets.precompile += %w( glyphicons-bootstrap.css )
Rails.application.config.assets.precompile += %w( fontastic.css )
Rails.application.config.assets.precompile += %w( bootstrap-multiselect.css )
Rails.application.config.assets.precompile += %w( font-awesome.min.css )
