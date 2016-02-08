class LandingPagesController < ApplicationController
  # debugger
  before_action :check_social_network
  #  before_action :logged_in_subject, only: [:create, :destroy]
  #  after_action  :set_screen_geometry, only: [:index, :landing_page, :home]
  #  before_action :set_landing_page, only: [:show, :edit, :update, :destroy]

  respond_to :js # except: [:home]

  include SessionsHelper
  helper_method :get_screen_geometry

  def home

    if load_social_network_from_url.nil?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404 and return
    end

    page = 'home'

    layout =
      if browser_height.to_s.length < 2
        'dummy'
      elsif logged_in?
        'application'
      elsif deploy? || stage_landing?
        'mail_collector'
      else
        session.destroy
        page = 'landing_page'
        'landing_page'
      end

    logger.debug 'LandingPagesController:home - '
    logger.debug "layout: #{layout}, page: #{page}, logged in?: #{logged_in?}, params: #{params}"

    respond_to do |format|
      format.html { render page, layout: layout }
      format.js { render page, layout: layout }
    end
  end

  def about
  end

  def contacts
  end

  def help
  end

  def privacy
  end

  def terms
  end

=begin

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
    @landing_page = LandingPage.new unless #landing_page.nil?
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
=end

 # private

  # Use callbacks to share common setup or constraints between actions.
  # def set_landing_page
    # @landing_page = LandingPage.find(params[:id])
  # end

=begin
    # Never trust parameters from the scary internet, only allow the white list through.
    def landing_page_params
      params.require(:landing_page).permit(:description, :logo, :header)
    end
=end
end
