Rails.application.routes.draw do

  get 'uters/new'

  root                    'static_pages#home'
  get   'about'     =>    'static_pages#about'
  get   'help'      =>    'static_pages#help'
  get   'contact'   =>    'static_pages#contact'

  get   'login'     =>    'static_pages#home'
  get   'signup'    =>    'users#new'

  resources :posts
  resources :users

end
