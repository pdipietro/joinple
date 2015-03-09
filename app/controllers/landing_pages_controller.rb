class LandingPagesController < ApplicationController
 
  before_action :check_social_network
  before_action :logged_in_user, only: [:create, :destroy]

  before_action :set_landing_page, only: [:show, :edit, :update, :destroy]

  respond_to :js, except: [:landing_page, :home]

  def about
  end

  def contacts
  end

  def help
  end

  def home
    puts "Home-Logged in? : #{logged_in?}"
    if load_social_network_from_url.nil?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      false
    end

  end

  def privacy
  end

  def terms
  end

  def landing_page
    puts "Carousel-Logged in? : #{logged_in?}"
    r='home'
    l="landing_pages"  
    if logged_in?
      r="home"
      l="application"
#    elsif current_social_network_name?.downcase == "gsn"
#      r='pre_carousel'
#      l="pre_carousel"  
    end
    render r, layout: l

  end


  # GET /landing_pages
  # GET /landing_pages.json
  def index
    @landing_page = LandingPage.first
    puts "SONO DENTRO LANDING_PAGE - INDEX"
    puts "@landing_page.uuid #{@landing_page}"
#    puts "@Landing: #{@landing_page}"
#    if @landing_page.nil?
#       @landing_page = LandingPage.new
#       x = @landing_page.save
#    end
    render layout: "application", format: :js, locals: { landing_page: @landing_page }
    #layout "application"
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
        redirect_to root_path #format.js   { render partial: "index", object: @landing_page, notice: 'Landing page was successfully updated.' }
      else
        format.js   { render :edit, object: @landing_page }
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
      params.require(:landing_page).permit(:description, :header, :logo, logo_attributes: [:attachment])
    end
end

