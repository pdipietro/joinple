class DiscussionsController < ApplicationController

  include DiscussionsHelper

  before_action :set_discussion, only: [:show, :edit, :update, :destroy, :list_one]
  before_action :check_social_network
  before_action :logged_in_user, only: [:create, :destroy]

  respond_to :js

 # GET group/:id/list/:filter(/:from_page(/:limit(/:subject(/:deep))))
  def list_one
    puts ("----- Discussion Controller: List_one --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]
    discussion_id = params[:discussion_id]

    puts "@discussion: #{@discussion}"

    basic_query = "(g:Discussion { uuid : '#{@discussion.uuid}' })"

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

    @users = Neo4j::Session.query.match(query_string).proxy_as(User, :user).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "user distinct",order: "user.last_name asc, user.first_name  asc")
  
    @users.each do |u|
      puts "User: #{u.last_name}"
    end

    render partial: "#{subject.name.pluralize.downcase}/list", locals: { discussions: @discussions, group: @group, users: @users, subset: filter, title: get_title(filter)}

  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Discussion Controller: List --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]
    dest_id = params[:id]

    show_group = ["allingroupsiparticipate","allicreated","alliparticipate"].include?(filter) 
    show_social = filter == "iparticipateinallsocialnetworks" ? true : false
    puts "===================== render list with show_group: '#{show_group}', filter: '#{filter}'"

    basic_query =
      if filter == "allingroupsiparticipate"
         "(g:Group)-[r2:belongs_to]->(s:SocialNetwork { uuid : '#{current_social_network_uuid?}'} ), (discussions)-[r:belongs_to]->(g) "
      elsif ["allicreated", "alliparticipate"].include?(filter)
         "(discussions)-[r:belongs_to]->(g:Group)-[r2:belongs_to]->(s:SocialNetwork { uuid : '#{current_social_network_uuid?}'} ) "
      elsif filter == "iparticipateinallsocialnetworks"
         "(discussions) "
      elsif ["alldiscussionsinagroup","mydiscussionsinagroup"].include?(filter)
        "(discussions)-[r:belongs_to]->(g:Group { uuid : '#{dest_id}'} ) "
      else
        "(discussions)-[r:belongs_to]->(g:Group { uuid : '#{current_group.uuid}'} ) "
      end 

    qstr =
      case filter
        when "allingroupsiparticipate"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:participates|owns]->"
        when "allicreated"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:owns|admins]->"
        when "iparticipate", "alliparticipate", "mydiscussionsinagroup"
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
        when "all","alldiscussionsinagroup"
              ""
        else 
             ""      
       end

    query_string = qstr << basic_query

    puts "===> #{query_string}"

    @result = Discussion.as(:discussions).query.match(query_string).proxy_as(Discussion, :discussions).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "distinct discussion", order: "discussions.created_at desc")

    puts "===================== render list with show_group: #{show_group}"

    render 'list', locals: { result: @result, subset: filter, title: get_title(filter), show_group: show_group, show_social: show_social}

  end


  # GET /discussions
  # GET /discussions.json
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)

    puts ("Discussion.class: #{@discussion.class}")
    puts ("current_group.class: #{current_group.class}")

    respond_to do |format|
      if @discussion.save
        rel = Owns.create(from_node: current_user, to_node: @discussion)
        rel = @discussion.create_rel("belongs_to", current_group)
        format.js   { render partial: "enqueue", object: @discussion, notice: 'Discussion was successfully created.' }
        format.html { redirect_to @discussion, notice: 'Discussion was successfully created.' }
        format.json { render :show, status: :created, location: @discussion }
      else
        format.js   { render :new, object: @discussion }
        format.html { render :new }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.js   { render partial: "replace", object: @discussion, notice: 'Discussion was successfully updated.' }
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion }
      else
        format.js   { render :edit, object: @discussion }
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    dest = @discussion.uuid
    @discussion.destroy
    reset_current_discussion
    respond_to do |format|
      format.js   { render partial: "shared/remove", locals: { dest: dest } }
      format.html { redirect_to discussions_url, notice: 'Discussion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:title, :description, :header, :header_cache)
    end
end
