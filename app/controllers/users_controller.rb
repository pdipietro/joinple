class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
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
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    puts "userparams: #{user_params} §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§"
    @user = User.new(user_params)

   # respond_to do |format|
      if @user.save
    #    log_in @user
    #    flash[:success] = "Welcome to the Gsn!"
    #    redirect_to @user
    #    format.json { render :show, status: :created, location: @user }
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
      else
        render :new
       # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    #end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
   # respond_to do |format|
   #   @user.check_default
   #   puts "User params: #{user_params} +++++++++++++++++++++++++++++++++++++++++++++++++++++"
      if @user.update(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
   #    format.json { render :show, status: :ok, location: @user }
      else
        render :edit
   #    format.json { render json: @user.errors, status: :unprocessable_entity }
      end
   # end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    #respond_to do |format|
      redirect_to users_url, notice: 'User was successfully destroyed.'
    #  format.json { head :no_content }
    #end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      # deleting a user is not allowed
      redirect_to(root_url) unless current_user.admin?
    end

  #  def check_default
  #    @user.check_default
  #    puts "CheckDefault done! #{@user.activation_token} - #{@user.last_name} --------------------------------------------------------------"
  #  end

end
