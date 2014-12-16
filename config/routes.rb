Rails.application.routes.draw do


 
  resources :social_networks

  resources :languages

  root                     'static_pages#home'
  get    'about'     =>    'static_pages#about'
  get    'help'      =>    'static_pages#help'
  get    'contact'   =>    'static_pages#contact'

  get    'login'     =>    'sessions#new'
  post   'login'     =>    'sessions#create'
  get    'signup'    =>    'users#new'
  delete 'logout'    =>    'sessions#destroy'

#  get    'password_resets/new'
#  get    'password_resets/edit'


#  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :users do
    member do
      get :following, :followers, :follows, :is_followed_by
    end
  end

  resources :users
  resources :posts #,               only: [:create, :destroy]






=begin
  root                    'static_pages#home'
  get   'about'     =>    'static_pages#about'
  get   'help'      =>    'static_pages#help'
  get   'contact'   =>    'static_pages#contact'

  get   'login'     =>    'sessions#new'
  post  'login'     =>    'sessions#create'
  get   'signup'    =>    'users#new'
  delete 'logout'   =>    'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :users


  resources :password_resets,     only: [:new, :create, :edit, :update]
=end
end
