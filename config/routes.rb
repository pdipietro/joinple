Rails.application.routes.draw do

  root                    'static_pages#home'
  get   'about'     =>    'static_pages#about'
  get   'help'      =>    'static_pages#help'
  get   'contact'   =>    'static_pages#contact'

  get   'login'     =>    'sessions#new'
  post  'login'     =>    'sessions#create'
  get   'signup'    =>    'users#new'
  delete 'logout'   =>    'sessions#destroy'

  resources :posts
  resources :users


  resources :password_resets,     only: [:new, :create, :edit, :update]

end
