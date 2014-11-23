Rails.application.routes.draw do

  root                  'static_pages#home'
  get   'about'     =>    'static_pages#about'
  get   'help'      =>    'static_pages#help'
  get   'contact'   =>    'static_pages#contact'

  get   'login'     =>    'static_pages#home'

  resources :posts
  resources :users

 	resources :languages

  get '/dashboard' => 'welcome#dashboard'

end
