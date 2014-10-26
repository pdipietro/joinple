Rails.application.routes.draw do

    get '/dashboard' => 'welcome#dashboard'
    root :to => "welcome#index"

    match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

    devise_scope :user do
      get '/api/current_user' => 'users/sessions#show_current_user'
      post '/api/check/is_user' => 'users/users#is_user', as: 'is_user'
#      get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
#      get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    end

#		scope '/api' do
#	  	resources :languages
#		end

		namespace :api do
	  	resources :languages
	  	resources :shares
		end

end
