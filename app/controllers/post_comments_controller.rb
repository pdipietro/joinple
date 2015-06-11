class PostCommentsController < ApplicationController
  before_action :set_post_comment, only: [:show, :edit, :update, :destroy]

  # GET /post_comments
  # GET /post_comments.json
  def index
    @post_comments = PostComment.all
  end

  # GET /post_comments/1
  # GET /post_comments/1.json
  def show
  end

  # GET /post_comments/new
  def new
    @post_comment = PostComment.new
  end

  # GET /post_comments/1/edit
  def edit
  end

  # POST /post_comments
  # POST /post_comments.json
  def create
    success = true
    @post_comment = PostComment.new(post_comment_params)

    post = Post.find(params[:post_uuid])

    begin
      tx = Neo4j::Transaction.new

      @post_comment.save
      rel = Owns.create(from_node: current_user, to_node: @post_comment)
      rel = HasPostComment.create(from_node: post, to_node: @post_comment)  
      
      rescue => e
        tx.failure
        success = false
      ensure
        tx.close

      respond_to do |format|
        unless success 
          puts "--------- /postComment/create: transaction failure: #{@post_comment.content}"
          format.js   { render :new, locals: { :post_comment => @post_comment, :post => post } }
          format.html { render :new }
          format.json { render json: @post_comment.errors, status: :unprocessable_entity }
        else
          puts "--------- /postComment/create: transaction succeeded: #{@post_comment.content}"
          format.js   { render partial: "enqueue", object: @post_comment, locals: { :post => post }, notice: 'Post was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @post_comment, user: @post_comment.is_owned_by }
        end
      end
    end
  end

  # PATCH/PUT /post_comments/1
  # PATCH/PUT /post_comments/1.json
  def update
    respond_to do |format|
      if @post_comment.update(post_comment_params)
        format.html { redirect_to @post_comment, notice: 'Post comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @post_comment }
      else
        format.html { render :edit }
        format.json { render json: @post_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_comments/1
  # DELETE /post_comments/1.json
  def destroy
    @post_comment.destroy
    respond_to do |format|
      format.html { redirect_to post_comments_url, notice: 'Post comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post_comment
      @post_comment = PostComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_comment_params
      params.require(:post_comment).permit(:content, :image, :uuid)
    end
    # params.require(:user).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation )
 
end
