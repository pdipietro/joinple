source 'http://rubygems.org'

#gemspec

gem 'rails', '4.2.0.beta4' # 4.1.5'
gem 'sass-rails', '~> 5.0.0.beta1'
gem "sass", "~> 3.3.0.rc.2"
gem "compass", "~> 0.13.alpha.12"
gem "compass-rails", "~> 2.0.alpha.0"
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'turbolinks' #, '2.3.0'
gem 'haml'
gem 'therubyrhino'
gem 'therubyracer'
gem 'jquery-rails', '4.0.0.beta2'
gem 'jbuilder', '~> 2.2.2'
gem 'bcrypt', '~> 3.1.7'
gem 'neo4j', :git => 'https://github.com/neo4jrb/neo4j.git'
gem 'devise-neo4j',  :git => 'git://github.com/andreasronge/devise-neo4j.git'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-gplus'
gem 'uuidtools'
gem 'github_api'
# gem 'neo4jrb-paperclip', :require => "neo4jrb_paperclip"
gem "rmagick4j"
# gem "carrierwave-neo4j", :require => "carrierwave/neo4j"

# gem 'neography'
# gem 'neo4j-will_paginate', path: 'vendor/gems/neo4j-will_paginate-0.2.1-java'
# gem 'will_paginate'
# gem 'bootstrap-will_paginate'

group :development, :test do
  gem 'minitest'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry'
# gem 'pry_rails'
  gem 'web-console', '2.0.0.beta4'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner', '0.7.0'
  gem 'growl', '1.0.3'

	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', '~> 0.4.0',          group: :doc

	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'

end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest'#,     '2.3.1'
end


platforms :jruby do
  gem 'neo4j-community', '~> 2.1.2'
end

gem 'rails-html-sanitizer', '1.0.1'
gem 'jquery-minicolors-rails'
gem 'bootstrap-sass'
gem 'foundation-rails'
gem 'bower-rails'
#gem 'angularjs-rails'
#gem 'angular-rails-templates'
gem 'ngmin-rails'
#gem 'zurb-foundation'

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end




