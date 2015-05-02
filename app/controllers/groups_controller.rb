class GroupsController < ApplicationController

  include GroupsHelper

  before_action :check_social_network
  before_action :set_group, only: [:show, :edit, :update, :destroy, :list_one]
  before_action :logged_in_user, only: [:create, :destroy]

  respond_to :js

  helper_method  :secondary_items_per_page, :get_group_subset, :get_posts_subset
 
 # GET group/:id/list/:filter(/:from_page(/:limit(/:subject(/:deep))))
  def list_one
    puts ("----- Group Controller: List_one --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]
    group_id = params[:group_id]

    puts "@group: #{@group}"

    basic_query = "(g:Group { uuid : '#{@group.uuid}' }) "

    subject = ""

    qstr =
      case filter
        when "members"
              subject = User
              "(user:User)-[p:participates|owns|admins]->"
        when "admins"
              subject = User
              "(user:User)-[p:owns|admins]->"
        when "events"
              ""
        when "discussions"
              subject = Discussion
              ""
        else 
             ""      
       end

    query_string = qstr << basic_query

    puts "Query: #{query_string}"

   # @users = subject.as(:users).query.match(query_string).proxy_as(User, :users).paginate(:page => first_page, :per_page => secondary_items_per_page, return: :users, order: "users.last_name asc, users.first_name  asc")
   # @users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "distinct user", order: "user.last_name asc, user.first_name  asc")
    @users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "distinct user", order: "user.last_name asc, user.first_name  asc")
    
    puts "Count: #{@users.count}"

    @users.each do |u|
      puts "User: #{u.last_name}"
    end

    render partial: "#{subject.name.pluralize.downcase}/list", locals: { group: @group, users: @users, subset: filter, title: get_title(filter)}

  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Group Controller: List --(#{params[:filter]})----------------------------------------")

    reset_current_group  

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(groups)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) "

    qstr =
      case filter
        when "iparticipate"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:participates|owns|admins]->"
        when "iadminister"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:owns|admins]->"
        when "mycontacts"
              "(user:User { uuid : '#{current_user.uuid}' })-[f:is_friend_of*1..2]->(afriend:User)-[p:owns]->"
        when "hot"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
        when "fresh"
              ""
        when "search"
              ""
        when "all"
              ""
        else 
             ""      
       end

    query_string = qstr << basic_query

    @groups = Group.as(:groups).query.match(query_string).proxy_as(Group, :groups).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "distinct groups", order: "groups.created_at desc")

    render 'list', locals: { groups: @groups, subset: filter, title: get_title(filter)}

  end

  # GET /groups
  # GET /groups.json
  def index
    puts ("----- Groups Controller: Index -----------------------------------------------------------")
    reset_current_group  

    filter = "iparticipate"
    @groups = get_group_subset(1,basic_items_per_page,filter)

    render 'index', locals: { groups: @groups, subset: filter, title: get_title(filter)}
  end

  # GET /groups/1
  # GET /groups/1.json
  def show

  end

  # GET /groups/new
  def new
    puts ("----- Groups Controller: new -----------------------------------------------------------")
    @group = Group.new
  end

  # GET /groups/1/edit
    puts ("----- Groups Controller: Edit -----------------------------------------------------------")
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    puts ("----- Groups Controller: Create -----------------------------------------------------------")
    @group = Group.new(group_params)

    respond_to do |format|
      puts ("1- @group.type:  #{@group.type}")
      if @group.save
        rel = Owns.create(from_node: current_user, to_node: @group)
        rel = BelongsTo.create(from_node: @group, to_node: current_social_network)
        format.js   { render partial: "enqueue", object: @group, notice: 'Group was successfully created.' }
        format.html { redirect_to(request.env["HTTP_REFERER"]) }
        format.json { render :show, status: :created, location: @group }
      else
        format.js   { render :new, object: @group }
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    puts ("----- Groups Controller: update -----------------------------------------------------------")
    respond_to do |format|
      if @group.update(group_params)
        format.js   { render partial: "replace", object: @group, notice: 'Group was successfully updated.' }
        format.html { render partial: "replace", object: @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.js   { render :edit, object: @group }
        format.html { render :edit, object: @group  }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    dest = @group.uuid
    @group.destroy
    respond_to do |format|
      format.js   { render partial: "shared/remove", locals: { dest: dest } }
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ################################ HELPERS METHODS ##########################

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end
  def basic_items_per_page
    BASIC_ITEMS_PER_PAGE
  end

=begin
  # GET /groups/list/:filter(/:limit(/:subject))
  def get_group_subset(actual_page, items_per_page, filter)
    puts "INTO  - (GroupsController) get_subset"
    query_string = prepare_query(filter)

    #puts "group - get subset - query string: #{query_string}"
    grp = Group.as(:groups).query.match(query_string).proxy_as(Group, :groups).paginate(:page => actual_page, :per_page => items_per_page, return: :groups, order: "groups.created_at desc")
    #puts "get_subset count: #{grp.count} - class: #{grp.class.name} - #{grp}"
    grp
  end

  # GET /posts/list/:filter(/:limit(/:subject))
  def get_post_subset (actual_page, items_per_page, filter)
    puts "INTO  - (postsController) get_subset"
    query_string = prepare_post_query(filter)

    #puts "post - get subset - query string: #{query_string}"
    post = Post.as(:posts).query.match(query_string).proxy_as(Post, :posts).paginate(:page => actual_page, :per_page => items_per_page, return: :posts, order: "posts.created_at desc")
    #puts "get_subset count: #{post.count} - class: #{post.class.name} - #{post}"
    post
  end
=end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description, :type, :background_color, :text_color,
        :logo, :header, :logo_cache, :header_cache)
    end
end
