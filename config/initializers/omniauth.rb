
Rails.application.config.middleware.use OmniAuth::Builder do

  options[:secret] ||= Rails.application.config.secret_token

#  use OmniAuth::Strategies::Developer

#  unless Rails.env.production?
#    provider :developer,
#      :fields => [:first_name, :last_name, :email],
#      :uid_field => :email
#  end
# provider :facebook, AppConfig.facebook['clientId'], AppConfig.facebook['clientSecret'] unless Rails.env.development?
#  provider :linkedin, AppConfig.linkedin['clientId'], AppConfig.linkedin['clientSecret']
#  provider :github,   AppConfig.github['clientId'],   AppConfig.github['clientSecret'], scope = AppConfig.github['scope']
#  provider :gplus,    AppConfig.gplus['clientId'],    AppConfig.gplus['clientSecret'], scope = AppConfig.gplus['scope']
#  provider :twitter,  AppConfig.twitter['clientId'],  AppConfig.twitter['clientSecret'],scope = AppConfig.twitter['scope']


# ["twitter","facebook","linkedin","gplus"].each do |p|
#      scope = AppConfig[p][:scope].nil? ? "" : ", " + AppConfig[p]['scope']
#      s = "provider :#{p}, AppConfig.#{p}['clientId'], AppConfig.#{p}['clientSecret'] " + scope
#      puts s
#      eval s
#  end

  on_failure { |env| UserIdentitiesController.action(:failure).call(env) }

end

# Rails.application.config.middleware.use OmniAuth::Strategies::Developer do

#  provider :developer unless Rails.env.production?

# end