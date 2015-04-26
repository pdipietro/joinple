Rails.application.routes.draw do


  root                     'landing_pages#home'#, defaults: { :format => "js"}, :remote => :true
  get    'home'      =>    'landing_pages#home', defaults: { :format => "js"}, :remote => :true
  get    'about'     =>    'static_pages#about', defaults: { :format => "js"}, :remote => :true
  get    'contacts'  =>    'static_pages#contacts', defaults: { :format => "js"}, :remote => :true
  get    'help'      =>    'static_pages#help', defaults: { :format => "js"}, :remote => :true
  get    'privacy'   =>    'static_pages#privacy', defaults: { :format => "js"}, :remote => :true
  get    'terms'     =>    'static_pages#terms', defaults: { :format => "js"}, :remote => :true

  get    'login'     =>    'sessions#new', defaults: { :format => "js"}, :remote => :true
  post   'login'     =>    'sessions#create', defaults: { :format => "js"}, :remote => :true
  get    'signup'    =>    'users#new', defaults: { :format => "js"}, :remote => :true
  delete 'logout'    =>    'sessions#destroy', defaults: { :format => "js"}, :remote => :true

  #get    'profile'   =>    'user_profiles#edit', defaults: { :format => "js"}, :remote => :true

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

  resources :users,               constraints: AuthConstraint.new,defaults: { :format => "js"}, :remote => :true,  except: [:destroy]

# administrative resources

  resources :languages,           constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :social_networks,     constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true,  except: [:destroy]

  resources :posts,               constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true     #, only: [:create, :destroy]
  resources :groups,              constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true

  resources :landing_pages,       constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true,  except: [:destroy]
  resources :tags,                constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :tests,               constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :images,              constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :media_managers,      constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :user_profiles,       constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true
  resources :post_comments,       constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true

  get       'groups/list(/:filter(/:from_page(/:limit(/:subject(/:deep)))))'  =>   'groups#list', :as => :groups_list, defaults: { :format => "js"}, :remote => :true
  get       'social_networks/list(/:filter(/:from_page(/:limit(/:subject(/:deep)))))'  =>   'social_networks#list', :as => :social_networks_list, defaults: { :format => "js"}, :remote => :true
  get       'user/list(/:filter(/:from_page(/:limit(/:subject(/:deep)))))'  =>   'user#list', :as => :users_list, defaults: { :format => "js"}, :remote => :true
#  get       'discussion/list(/:filter(/:from_page(/:limit(/:subject(/:deep)))))'  =>   'discussion#list', :as => :discussions_list, defaults: { :format => "js"}, :remote => :true
#  get       'post/list(/:filter(/:from_page(/:limit(/:subject(/:deep)))))'  =>   'post#list', :as => :posts_list, defaults: { :format => "js"}, :remote => :true

  post      'likes/:id/:class/:rel_type'    =>    'likes#edit',           :as => :onerel, constraints: AuthConstraint.new
  get       'likes'                         =>    'likes#dummy',          :as => :dummy, constraints: AuthConstraint.new
  post      'search'                        =>    'likes#search',         :as => :search, constraints: AuthConstraint.new
  get       '/media_managers/list/'         =>    'media_managers#list',  :as => :image_list #, defaults: { :format => "js"}, :remote => :true
 # get       'user_profiles'                 =>    'user_profiles#edit',    :as => :edit, constraints: AuthConstraint.new, defaults: { :format => "js"}, :remote => :true

end
