class DiscussionCommentsController < ApplicationController
  before_action :set_discussion_comment, only: [:show, :edit, :update, :destroy]


  # GET /dicsussion_comment/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Group Controller: List --(#{params[:filter]})----------------------------------------")

    reset_current_group  

    filter = params[:filter]
    actual_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(discussions:Discussion)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) "
    #with distinct ugroups as groups"

    qstr =
      case filter
        when "iparticipate"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:participates|owns|admins]->"
        when "iadminister"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:owns|admins]->"
        when "mycontacts"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[f:is_friend_of*1..2]->(afriend:Subject)-[p:owns]->"
        when "hot"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:owns]->"
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

    render 'list', locals: { groups: @groups, subset: filter, title: get_title(filter), from_page: first_page + 1}

  end
  # GET /discussion_comments
  # GET /discussion_comments.json
  def index
    @discussion_comments = DiscussionComment.all
  end

  # GET /discussion_comments/1
  # GET /discussion_comments/1.json
  def show
  end

   # GET /discussion_comments/new 
  def new
    @discussion_comment = DiscussionComment.new
    parent_class = params[:parent_class]
    parent_uuid = params[:parent_uuid]

    render :new, locals: { :discussion_comment => @discussion_comment, :parent_class => parent_class, :parent_uuid  => parent_uuid } 
  end

  # GET /discussion_comments/1/edit
  def edit
  end

  # POST /discussion_comments
  # POST /discussion_comments.json
  def create
    success = true
    @discussion_comment = DiscussionComment.new(discussion_comment_params)

    parent_class = params[:parent_class]
    parent_uuid = params[:parent_uuid]

    parent = parent_class == "DiscussionComment" ? DiscussionComment.find(parent_uuid) : Discussion.find(parent_uuid);

    puts "parent: #{parent_class}:#{parent_uuid}"
    puts "check parent: #{parent.class.name}:#{parent.uuid}"

    begin
      tx = Neo4j::Transaction.new

      @discussion_comment.save
      puts "Discussion_comment_uuid: #{@discussion_comment.uuid}"

      rel = Owns.create(from_node: current_subject, to_node: @discussion_comment)
      puts "rel: #{rel}"
      #rel = HasComment.create(from_node: parent, to_node: @discussion_comment)  
      #puts "rel: #{rel}"
      rel = parent.create_rel("has_comment", @discussion_comment)
      puts "rel: #{rel}"
    
      rescue => e
        tx.failure
        success = false
      ensure
        tx.close

      respond_to do |format|
        unless success 
          puts "--------- /discussionComment/create: transaction failure: #{@discussion_comment.content}"
          format.js   { render :new, object: @discussion_comment, locals: { :parent_class => parent_class, parent_uuid  => parent_uuid } }
          format.html { render :new }
          format.json { render json: @discussion_comment.errors, status: :unprocessable_entity }
        else
          puts "--------- /discussionComment/create: transaction succeeded: #{@discussion_comment.content}"
          format.js   { render partial: "enqueue", object: @discussion_comment, locals: { :parent_class => parent_class, parent_uuid  => parent_uuid  }, notice: 'Post was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @discussion_comment, subject: @discussion_comment.is_owned_by }
        end
      end
    end
  end

  # PATCH/PUT /discussion_comments/1
  # PATCH/PUT /discussion_comments/1.json
  def update
    respond_to do |format|
      if @discussion_comment.update(discussion_comment_params)
        format.html { redirect_to @discussion_comment, notice: 'Post comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion_comment }
      else
        format.html { render :edit }
        format.json { render json: @discussion_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_comments/1
  # DELETE /discussion_comments/1.json
  def destroy
    @discussion_comment.destroy
    respond_to do |format|
      format.html { redirect_to discussion_comments_url, notice: 'Post comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion_comment
      @discussion_comment = DiscussionComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_comment_params
      params.require(:discussion_comment).permit(:content, :image, :uuid, :parent_class, :parent_uuid)
    end
 
end
