class UsersController < ApplicationController
  before_action :check_social_network, only: [:show]
  before_action :logged_in_user, only: [:index, :edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :set_user,       only: [:show, :edit, :update]
#  before_action :check_default,  only: [:create, :update]

  respond_to :js

  #helper_method  :secondary_items_per_page, :get_group_subset, :get_posts_subset
 
  # GET /users/list/:filter(/:limit(/:subject))
  def list
    puts ("----- User Controller: List --(get       'users/list/:class_name/:object_id/:rel(/from_page(/:limit(/:subject(/:deep))))'----------------------------------------")

    class_name = params[:class]
    object_id = params[:object_id]
    filter = params[:rel]

    puts "+++++++++++++++++++++++++++++++++++++ #{class_name} +++++++++ #{object_id} +++++++++++++++++ #{filter} ++++++++++++++++++++"

    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(dest:#{class_name} { uuid : '#{object_id}'})-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network_uuid?}'} ) "

    qstr =
      case filter
        when "likes"
              "(users:User)-[p:likes]->(dest:#{class_name} { uuid : '#{object_id}'})" 
        when "shares"
              "(users:User)-[p:shares]->(dest:#{class_name} { uuid : '#{object_id}'})" 
        when "preferes"
              "(users:User)-[p:preferes->(dest:#{class_name} { uuid : '#{object_id}'})"
        when "ifollowing"
              "(me:User { uuid : '#{current_user_id?}'})-[p:follows]->(users:User)"
        when "ifollower"
              "(me:User { uuid : '#{current_user_id?}'})<-[p:follows]-(users:User)"
        when "all"
              "(user:User)"
        else 
             ""      
       end

    puts "---------------- Query: #{qstr}"

    @users = Neo4j::Session.query.match(qstr).proxy_as(User, :users).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "user distinct", order: "users.last_name asc, users.first_name asc")

    if class_name == "Users"
      render 'index', object: @users
    else
      render 'likes/show_content', locals: { objects: @users, subset: filter, form_path: "users/list", title: get_title(filter,class_name)}
    end
  end

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
    puts "UsersController.show start"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group.name unless current_group.nil?} - group admin: #{is_group_admin?}"
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
    #    flash[:success] = "Welcome to the JoinPle Social Network!"
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


    def get_title(filter,class_name = "")
        case filter
          when "all"
                "All users"
          when "ifollowing"
                "Users I follow"
          when "ifollower"
                "Users following me"
          when "likes"
                "#{class_name.pluralize} I smile"
          when "shares"
                "things I've shared"
          when "preferes"
                "User I prefere"
          else 
             "TITLE MISSED"  
             raise 565    
        end
    end


end
