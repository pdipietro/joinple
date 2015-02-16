Rails.application.routes.draw do

  root                     'static_pages#carousel'#, defaults: { :format => "js"}, :remote => :true
  get    'home'      =>    'static_pages#home'#, defaults: { :format => "js"}, :remote => :true
  get    'about'     =>    'static_pages#about', defaults: { :format => "js"}, :remote => :true
  get    'contacts'  =>    'static_pages#contacts', defaults: { :format => "js"}, :remote => :true
  get    'help'      =>    'static_pages#help', defaults: { :format => "js"}, :remote => :true
  get    'privacy'   =>    'static_pages#privacy', defaults: { :format => "js"}, :remote => :true
  get    'terms'     =>    'static_pages#terms', defaults: { :format => "js"}, :remote => :true

  get    'login'     =>    'sessions#new', defaults: { :format => "js"}, :remote => :true
  post   'login'     =>    'sessions#create', defaults: { :format => "js"}, :remote => :true
  get    'signup'    =>    'users#new', defaults: { :format => "js"}, :remote => :true
  delete 'logout'    =>    'sessions#destroy', defaults: { :format => "js"}, :remote => :true
# unused?  post   'switch/:sn' =>   'sessions#switch', defaults: { :format => "js"}, :remote => :true, as: :session_switch

#  get    'password_resets/new'
#  get    'password_resets/edit.

  resources :account_activations, only: [:edit], defaults: { :format => "js"}, :remote => :true
  resources :password_resets, only: [:new, :create, :edit, :update], defaults: { :format => "js"}, :remote => :true

  resources :users, :remote => :true do
    member do
      get :following, :followers, :likes, :preferes,  :follows, :is_followed_by #, :likes_to, :is_prefered_by
    end
  end

  resources :users, defaults: { :format => "js"}, :remote => :true

# administrative resources



  resources :languages, constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :social_networks, constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true

  resources :posts, constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true     #,               only: [:create, :destroy]
  resources :groups, defaults: { :format => "js"}, :remote => :true

  post      '/groups/list/:filter(/:limit(/:subject))'  =>   'groups#list', :as => :group_list, defaults: { :format => "js"}, :remote => :true
  post      'likes/:id/:class/:rel_type'    =>    'likes#edit', constraints: AuthConstraint.new, :as => :onerel
  get       'likes'                         =>    'likes#dummy', constraints: AuthConstraint.new, :as => :dummy
  post      'search'                        =>    'likes#search', constraints: AuthConstraint.new, :as => :search




end
