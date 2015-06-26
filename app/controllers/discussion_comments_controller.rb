class DiscussionCommentsController < ApplicationController
  before_action :set_discussion_comment, only: [:show, :edit, :update, :destroy]

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
  end

  # GET /discussion_comments/1/edit
  def edit
  end

  # POST /discussion_comments
  # POST /discussion_comments.json
  def create
    success = true
    @discussion_comment = DiscussionComment.new(discussion_comment_params)

    discussion = Discussion.find(params[:discussion_uuid])
    puts "Discussion_uuid: #{params[:discussion_uuid]}"


    begin
      tx = Neo4j::Transaction.new

      @discussion_comment.save
    puts "Discussion_comment_uuid: #{@discussion_comment.uuid}"

      rel = Owns.create(from_node: current_user, to_node: @discussion_comment)
      puts "rel: #{rel}"
      rel = HasDiscussionComment.create(from_node: discussion, to_node: @discussion_comment)  
      puts "rel: #{rel}"
      
      rescue => e
        tx.failure
        success = false
      ensure
        tx.close

      respond_to do |format|
        unless success 
          puts "--------- /discussionComment/create: transaction failure: #{@discussion_comment.content}"
          format.js   { render :new, locals: { :discussion_comment => @discussion_comment, :discussion => discussion } }
          format.html { render :new }
          format.json { render json: @discussion_comment.errors, status: :unprocessable_entity }
        else
          puts "--------- /discussionComment/create: transaction succeeded: #{@discussion_comment.content}"
          format.js   { render partial: "enqueue", object: @discussion_comment, locals: { :discussion => discussion }, notice: 'Post was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @discussion_comment, user: @discussion_comment.is_owned_by }
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
      params.require(:discussion_comment).permit(:content, :image, :uuid)
    end
    # params.require(:user).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation )
 
end
