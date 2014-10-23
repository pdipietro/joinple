class WelcomeController < ApplicationController
  before_filter :authenticate_user_identity!, except: [:index]
  layout  :choose_layout

  def index
  end

  def dashboard
  end

  def choose_layout
      signed_in? ? "angular" : "application"
  end
end
