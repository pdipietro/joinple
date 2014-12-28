Rails.application.routes.draw do

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
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :users do
    member do
      get :following, :followers, :likes, :preferes,  :follows, :is_followed_by #, :likes_to, :is_prefered_by
    end
  end

  resources :users

# administrative resources

  resources :posts, constraints: AuthConstraint.new     #,               only: [:create, :destroy]
  resources :social_networks, constraints: AuthConstraint.new
  resources :languages, constraints: AuthConstraint.new
  resources :groups, constraints: AuthConstraint.new
  resources :likes, constraints: AuthConstraint.new, only: [:add, :remove]

end
