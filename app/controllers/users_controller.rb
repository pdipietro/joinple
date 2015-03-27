class UsersController < ApplicationController
  before_action :check_social_network, only: [:show]
  before_action :logged_in_user, only: [:index, :edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :set_user,       only: [:show, :edit, :update]
#  before_action :check_default,  only: [:create, :update]

  # GET /users
  # GET /users.json
  def index
     @users = User.all
  #  @users = User.as(:t).where('true = true').paginate(:page => params[:page], :per_page => 20)
  #  @users = User.as(:t).where('true = true WITH t ORDER BY t.first_name, t.last_name desc').paginate(:page => params[:page], :per_page => 20)
  #  @users = User.all.paginate(page: params[:page])
     respond_to do |format|
         format.js
     end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    puts "UsersController.show start"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group_name?} - group admin: #{is_group_admin?}"
    @posts = Post.all.order(created_at:  :desc)
    @user = User.find(params[:id])
    respond_to do |format|
      format.js 
#        format.html
    end
  end

  # GET /users/new
  def new
    puts "ready to call new.js.erb"
    @user = User.new
    #render layout: "landing_page"
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
         aProfile = UserProfile.new
         aProfile.save           
         rel = HasUserProfile.create(from_node: @user, to_node: aProfile)
         #@user.save

    #    log_in @user
    #    flash[:success] = "Welcome to the Gsn!"
    #    redirect_to @user
    #    format.json { render :show, status: :created, location: @user }
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url, format: :js
      else
       puts "-------------------------------- user create error: #{@user.errors}"
       render :new, format: :js
       # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
   # respond_to do |format|
   #   @user.check_default
   #   puts "User params: #{user_params} +++++++++++++++++++++++++++++++++++++++++++++++++++++"
      if @user.update(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user, format:  :js
   #    format.json { render :show, status: :ok, location: @user }
      else
        render :edit, format: :js
   #    format.json { render json: @user.errors, status: :unprocessable_entity }
      end
   # end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    #respond_to do |format|
      redirect_to users_url, format: :js, notice: 'User was successfully destroyed.'
    #  format.json { head :no_content }
    #end
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation )
    end

    # Before filters

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # admin services are reserved to admin users only
    def check_admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  #  def check_default
  #    @user.check_default
  #    puts "CheckDefault done! #{@user.activation_token} - #{@user.last_name} --------------------------------------------------------------"
  #  end

end
