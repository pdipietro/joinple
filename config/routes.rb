Rails.application.routes.draw do

  get 'secrets/show'

#    get "/auth/:action/callback", :to => "autentications", :constraints => { :action => /twitter|google|facebook/ }

#    devise_for :identities
    root :to => "secrets#show"

    match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
    match '/logout', to: 'sessions#destroy', via: [:get, :post]

    devise_for :user_identity, :controllers => { :omniauth_callbacks => "user_identities/omniauth_callbacks" }
    devise_scope :user_identity do
        get  '/api/current_identity' => 'user_identities/sessions#show_current_user_identity', as: 'show_current_user_identity'
        get  '/api/current_user' => 'users/sessions#show_current_user', as: 'show_current_user'
        post '/api/check/is_identity' => 'user_identities/user_identities#is_user_identity', as: 'is_user_identity'
    end

		scope '/api' do
	  	resources :languages
	  	resources :users
      resources :shares
      resources :identities
		end

    get '/dashboard' => 'welcome#dashboard'
   # root to: 'welcome#index'

		get "*path.html" => "application#index", :layout => 0
    get '*path' => 'application#index'

end
