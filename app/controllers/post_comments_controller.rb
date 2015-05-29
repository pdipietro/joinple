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
    @post_comment = PostComment.new(post_comment_params)

    post_uuid = params[:post_uuid]
    puts "post_uuid done: #{post_uuid}"

    respond_to do |format|
      begin
        tx = Neo4j::Transaction.new
          @post_comment.save

          puts "@post_comment.save ERROR: #{@post_comment.errors}" unless @post_comment.errors.count == 0
          puts "@post_comment.save DONE: #{@post_comment.errors}" if @post_comment.errors.count == 0

          rel = Owns.create(from_node: current_user, to_node: @post_comment)

          puts "Owns.create ERROR: #{rel.errors}" unless rel.errors.count == 0
          puts "Owns.create DONE: #{rel.errors}" if rel.errors.count == 0

          post = Post.find(post_uuid)

          puts "Post comment: #{post.content}"

          puts "Post.find ERROR: #{post.errors}" unless post.errors.count == 0
          puts "Post.find DONE: #{post.errors}" if post.errors.count == 0
          
          rel = post.create_rel(:has_comment, @post_comment)  
          
          puts "post.create_rel ERROR: #{rel.errors}" unless rel.errors.count == 0
          puts "post.create_rel DONE: #{rel.errors}" if rel.errors.count == 0
 
        rescue => e
          tx.failure
          puts "--------- /postComment/create: transaction failure: #{@post_comment.content}"
          format.js   { render :new, locals: { :post_comment => @post_comment, :post => post } }
          format.html { render :new }
          format.json { render json: @post_comment.errors, status: :unprocessable_entity }
        ensure
          tx.close
          puts "--------- /postComment/create: transaction succeeded: #{@post_comment.content}"
          format.js   { render partial: "enqueue", object: @post_comment, locals: { :post => post }, notice: 'Post was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @post_comment, user: @post_comment.is_owned_by }
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
      params.require(:post_comment).permit(:content, :image, :post_uuid)
    end
    # params.require(:user).permit(:nickname, :first_name, :last_name, :email, :password, :password_confirmation )
 
end
