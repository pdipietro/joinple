class LandingPagesController < ApplicationController
 
  before_action :check_social_network
  before_action :logged_in_subject, only: [:create, :destroy]
  after_action :set_screen_geometry, only: [:index, :landing_page, :home]
  before_action :set_landing_page, only: [:show, :edit, :update, :destroy]

  respond_to :js #, except: [:home]

  include SessionsHelper
  helper_method :get_screen_geometry

  def about
  end

  def contacts
  end

  def help
  end

  def home

    if is_deploy  or is_dev
      layout="mail_collector"
      page="home"
    else
      puts params
      screen_geometry= params
      puts "Home-Logged in? : #{logged_in?}"
      if load_social_network_from_url.nil?
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404
        false
      end

      if session[:height].to_s.length < 2
        layout='dummy'
        page='home'
      elsif logged_in?
        layout="application"
        page="home"
      else
        layout='landing_page'   
        page='landing_page'
      end 
    end

    respond_to do |format|
      format.html {render layout: layout }
      format.js {render layout: layout }
    end
  end

  def privacy
  end

  def terms
  end

  # POST /landing_page
  def landing_page
    puts params
    screen_geometry= params
    r='landing_page'
    l="landing_page"  
    if logged_in?
      r="home"
      l="application"
    end
    render r, layout: l
  end


  # GET /landing_pages
  # GET /landing_pages.json
  def index
    @landing_page = LandingPage.first
    puts "SONO DENTRO LANDING_PAGE - INDEX"
    puts "@landing_page.uuid #{@landing_page}"
    render layout: "application", format: :js, locals: { landing_page: @landing_page }
  end

  # GET /landing_pages/1
  # GET /landing_pages/1.json
  def show
  end

  # GET /landing_pages/1/edit
  def edit
  end

  # POST /landing_pages
  # POST /landing_pages.json
  def create
    puts "landing_page_params: #{landing_page_params}"
    @landing_page = LandingPage.new(landing_page_params)

    respond_to do |format|
      if @landing_page.save
        format.html { redirect_to @landing_page, notice: 'Landing page was successfully created.' }
        format.json { render :show, status: :created, location: @landing_page }
      else
        format.html { render :new }
        format.json { render json: @landing_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /landing_pages/1
  # PATCH/PUT /landing_pages/1.json
  def update

    respond_to do |format|
      if @landing_page.update(landing_page_params)
        format.js  { redirect_to root_path } #format.js   { render partial: "index", object: @landing_page, notice: 'Landing page was successfully updated.' }
      else
        format.js  { render :edit, object: @landing_page }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def landing_page_params
      params.require(:landing_page).permit(:description, :logo, :header)
    end

    def get_request_cookie
      set_screen_geometry
      puts "request cookies:"
      @width = cookies[:width]
      @height = cookies[:height]
      @pixelRatio = cookies[:pixelRatio]
      puts "@width: #{@width}"
      puts "@height: #{@height}"
      puts "@pixelRatio: #{@pixelRatio}"

    end
end

