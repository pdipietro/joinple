class SubjectsController < ApplicationController
  before_action :check_social_network, only: [:show]
  before_action :logged_in_subject, only: [:index, :edit, :update, :show]
  before_action :correct_subject,   only: [:edit, :update]
  before_action :admin_subject,     only: :destroy
  before_action :set_subject,       only: [:show, :edit, :update]
#  before_action :check_default,  only: [:create, :update]

  respond_to :js

  #helper_method  :secondary_items_per_page, :get_group_subset, :get_posts_subset
 
  # GET /subjects/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Subject Controller: List --(get       'subjects/list/:class_name/:object_id/:rel(/from_page(/:limit(/:subject(/:deep))))'----------------------------------------")

    class_name = params[:class]
    object_id = params[:object_id]
    filter = params[:rel]

    puts "+++++++++++++++++++++++++++++++++++++ #{class_name} +++++++++ #{object_id} +++++++++++++++++ #{filter} ++++++++++++++++++++"

    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(dest:#{class_name} { uuid : '#{object_id}'})-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network_uuid?}'} ) "

    qstr =
      case filter
        when "likes"
              "(subjects:Subject)-[p:likes]->(dest:#{class_name} { uuid : '#{object_id}'})" 
        when "shares"
              "(subjects:Subject)-[p:shares]->(dest:#{class_name} { uuid : '#{object_id}'})" 
        when "preferes"
              "(subjects:Subject)-[p:preferes->(dest:#{class_name} { uuid : '#{object_id}'})"
        when "ifollowing"
              "(me:Subject { uuid : '#{current_subject_id?}'})-[p:follows]->(subjects:Subject)"
        when "ifollower"
              "(me:Subject { uuid : '#{current_subject_id?}'})<-[p:follows]-(subjects:Subject)"
        when "all"
              "(subject:Subject)"
        else 
             ""      
       end

    puts "---------------- Query: #{qstr}"

    @subjects = Neo4j::Session.query.match(qstr).proxy_as(Subject, :subjects).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "subject distinct", order: "subjects.last_name asc, subjects.first_name asc")

    if class_name == "Subjects"
      render 'index', object: @subjects
    else
      render 'likes/show_content', locals: { objects: @subjects, subset: filter, form_path: "subjects/list", title: get_title(filter,class_name)}
    end
  end

  # GET /subjects
  # GET /subjects.json
  def index
     @subjects = Subject.all
  #  @subjects = Subject.as(:t).where('true = true').paginate(:page => params[:page], :per_page => 20)
  #  @subjects = Subject.as(:t).where('true = true WITH t ORDER BY t.first_name, t.last_name desc').paginate(:page => params[:page], :per_page => 20)
  #  @subjects = Subject.all.paginate(page: params[:page])
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    puts "SubjectsController.show start"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, subject: #{current_subject.nickname unless current_subject.nil?}, admin: #{is_admin?} - group: #{current_group.name unless current_group.nil?} - group admin: #{is_group_admin?}"
    @posts = Post.all.order(created_at:  :desc)
    @subject = Subject.find(params[:id])
    respond_to do |format|
      format.js 
#        format.html
    end
  end

  # GET /subjects/new
  def new
    puts "ready to call new.js.erb"
    @subject = Subject.new
    #render layout: "landing_page"
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
         aProfile = SubjectProfile.new
         aProfile.save           
         rel = HasSubjectProfile.create(from_node: @subject, to_node: aProfile)
         #@subject.save

    #    log_in @subject
    #    flash[:success] = "Welcome to the JoinPle Social Network!"
    #    redirect_to @subject
    #    format.json { render :show, status: :created, location: @subject }
        @subject.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url, format: :js
      else
       puts "-------------------------------- subject create error: #{@subject.errors}"
       render :new, format: :js
       # format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
   # respond_to do |format|
   #   @subject.check_default
   #   puts "Subject params: #{subject_params} +++++++++++++++++++++++++++++++++++++++++++++++++++++"
      if @subject.update(subject_params)
        flash[:success] = "Profile updated"
        redirect_to @subject, format:  :js
   #    format.json { render :show, status: :ok, location: @subject }
      else
        render :edit, format: :js
   #    format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
   # end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    #respond_to do |format|
      redirect_to subjects_url, format: :js, notice: 'Subject was successfully destroyed.'
    #  format.json { head :no_content }
    #end
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation )
    end

    # Before filters

    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Confirms the correct subject.
    def correct_subject
      @subject = Subject.find(params[:id])
      redirect_to(root_url) unless current_subject?(@subject)
    end

    # admin services are reserved to admin subjects only
    def check_admin_subject
      redirect_to(root_url) unless current_subject.admin?
    end

  #  def check_default
  #    @subject.check_default
  #    puts "CheckDefault done! #{@subject.activation_token} - #{@subject.last_name} --------------------------------------------------------------"
  #  end


    def get_title(filter,class_name = "")
        case filter
          when "all"
                "All subjects"
          when "ifollowing"
                "Subjects I follow"
          when "ifollower"
                "Subjects following me"
          when "likes"
                "#{class_name.pluralize} I smile"
          when "shares"
                "things I've shared"
          when "preferes"
                "Subject I prefere"
          else 
             "TITLE MISSED"  
             raise 565    
        end
    end


end
