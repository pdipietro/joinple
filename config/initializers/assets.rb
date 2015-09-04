# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( ./../images/* )

Rails.application.config.assets.precompile += %w( salvattore.js )
Rails.application.config.assets.precompile += %w( salvattore.min.js )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )

Rails.application.config.assets.precompile += %w( social/*_bootstrap.css )

Rails.application.config.assets.precompile += %w( ./../fonts/icomoon.eot )
Rails.application.config.assets.precompile += %w( ./../fonts/icomoon.ttf )
Rails.application.config.assets.precompile += %w( ./../fonts/icomoon.woff )
Rails.application.config.assets.precompile += %w( ./../fonts/icomoon.svg )

Rails.application.config.assets.precompile += %w( salvattore.css )
Rails.application.config.assets.precompile += %w( bootstrap-multiselect.css )
Rails.application.config.assets.precompile += %w( icomoon.css )

Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( landing-page.css )

Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( jquery.ui.widget.js )
Rails.application.config.assets.precompile += %w( jquery.iframe-transport.js )
Rails.application.config.assets.precompile += %w( jquery.fileupload.js )
Rails.application.config.assets.precompile += %w( jquery.cloudinary.js )
