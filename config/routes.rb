Rails.application.routes.draw do

  get 'static_pages/home'

  get 'static_pages/help'

  resources :posts

  resources :users

    resources :users
  	resources :languages
    resources :posts

    get '/dashboard' => 'welcome#dashboard'
    root :to => 'welcome#index'

end
