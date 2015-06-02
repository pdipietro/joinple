class GroupsController < ApplicationController

  include GroupsHelper

  before_action :check_social_network
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action  :set_current_group_loc, only: [:show, :list_one]
  before_action  :reset_current_group_loc, only: [:edit, :update, :destroy, :create]

  respond_to :js

 # helper_method  :secondary_items_per_page, :get_group_subset, :get_posts_subset
 
 # GET group/:id/list/:filter(/:from_page(/:limit(/:subject(/:deep))))
  def list_one
    puts ("----- Group Controller: List_one --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]
    group_uuid = params[:id]

    basic_query = "(g:Group { uuid : '#{group_uuid}' })"

    subject = q = ""
    @collections = @events = @users = ""

    case filter
      when "members"
            subject = User
            query = "(user:User)-[p:participates|owns|admins]->" << basic_query 
            @users = Neo4j::Session.query.match(query).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "user distinct",order: "user.last_name asc, user.first_name  asc")
      when "admins"
            subject = User
            query = "(user:User)-[p:owns|admins]->" << basic_query
            @users = Neo4j::Session.query.match(query).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "user distinct",order: "user.last_name asc, user.first_name  asc")
      when "alldiscussions"
            subject = Discussion
            query = "(discussion:Discussion)-[b:belongs_to]->" << basic_query
            @discussions = Neo4j::Session.query.match(query).proxy_as(Discussion, :discussion).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "discussion distinct",order: "discussion.modified_at desc")
      when "mydiscussions"
            subject = Discussion
            query = "(user:User { uuid : '#{current_user_id?}' })-[p:participates|owns|admins]->(discussion:Discussion)-[b:belongs_to]->" << basic_query
            @discussions = Neo4j::Session.query.match(query).proxy_as(Discussion, :discussion).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "discussion distinct",order: "discussion.modified_at desc")
      when "allevents"
            subject = Event
            query = "(event:Event)-[b:belongs_to]->" << basic_query
            @events = Neo4j::Session.query.match(query).proxy_as(Event, :event).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "event distinct",order: "event.date asc")
      when "myevents"
            subject = Event
            query = "(user:User { uuid : '#{current_user_uuid?}' })-[p:participates|owns|admins]->(event:Event)-[b:belongs_to]->" << basic_query
            @events = Neo4j::Session.query.match(query).proxy_as(Event, :event).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "event distinct",order: "event.date asc")
      else 
           ""      
     end

    puts "Query: #{query}"

   # @users = subject.as(:users).query.match(query_string).proxy_as(User, :users).paginate(:page => first_page, :per_page => secondary_items_per_page, return: :users, order: "users.last_name asc, users.first_name  asc")
   # @users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "distinct user", order: "user.last_name asc, user.first_name  asc")
   # @users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: ":user distinct",order: "user.last_name asc, user.first_name  asc")
    #@users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "user distinct",order: "user.last_name asc, user.first_name  asc")
  
    render partial: "#{subject.name.pluralize.downcase}/list", locals: { group: @group, users: @users, events: @events, discussions: @discussions, subset: filter, title: get_title(filter)}

  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Group Controller: List --(#{params[:filter]})----------------------------------------")

    reset_current_group  

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(groups:Group)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) "
    #with distinct ugroups as groups"

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

    @groups = Group.as(:groups).query.match(query_string).proxy_as(Group, :groups).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "groups", order: "groups.created_at desc")

    render 'list', locals: { groups: @groups, subset: filter, title: get_title(filter)}

  end

  # GET /groups
  # GET /groups.json
  def index
    puts ("----- Groups Controller: Index -----------------------------------------------------------")

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
      begin
        tx = Neo4j::Transaction.new
          @group.save
          rel = Owns.create(from_node: current_user, to_node: @group)
          rel = BelongsTo.create(from_node: @group, to_node: current_social_network)
        rescue => e
          tx.failure
          format.js   { render :new, object: @group }
          format.html { render :new }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        ensure
          tx.close
          format.js   { render partial: "enqueue", object: Group.new, notice: 'Group was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @group }
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
    reset_current_group
    
    respond_to do |format|
      format.js   { render partial: "shared/remove", locals: { dest: dest } }
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

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

    def remove_group
      reset_current_group
      puts ("Group has been reset")
    end

    def set_current_group_loc
      set_current_group(params[:id])
      puts ("Group by session: #{current_group.name}")
    end

    def reset_current_group_loc
      reset_current_group
      puts ("Current group reset")
    end

    def get_title(filter)
        case filter
          when "iparticipate"
                "My groups"
          when "iadminister"
                "Groups I administer"
          when "mycontacts"
                "My contact's groups"
          when "hot"
                "Hot groups"
          when "fresh"
                "Fresh groups"
          when "search"
                ""
          when "all"
                "All groups"
          when "members"
                "Group members"
          when "admins"
                "Group admins"
          when "alldiscussions"
                "All discussions"
          when "mydiscussions"
                "My discussions"
          when "allevents"
                "All events"
          when "myevents"
                "My events"
          else 
               "Groups"      
        end
    end

end
