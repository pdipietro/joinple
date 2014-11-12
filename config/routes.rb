Rails.application.routes.draw do

#    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

    devise_scope :user do
      get '/api/current_user' => 'users/sessions#show_current_user', as: 'show_current_user'
      post '/check/is_user' => 'users/users#is_user', as: 'is_user'
      post '/current_user' => 'users/sessions#get_current_user'
      get 'sign_in' => 'devise/sessions#new'#, :as => :new_user_session
	    get 'sign_out' => 'devise/sessions#destroy'#, :as => :destroy_user_session
	  end

	  scope '/api' do
    	resources :shares
      devise_for :users,
        :controllers => {
          :omniauth_callbacks => "users/omniauth_callbacks",
          :registrations => "users/registrations",
          :sessions => "users/sessions"
        }
	  end

    get '/dashboard' => 'welcome#dashboard'
    root :to => 'welcome#index'

end
