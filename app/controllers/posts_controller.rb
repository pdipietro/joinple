class PostsController < ApplicationController
  before_action :check_social_network
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :create, :destroy]

  respond_to :js

  #helper_method  :get_post_subset

 # GET /posts/list/:filter(/:limit(/:subject))
  def list
    filter = params[:filter]
    puts params[:from_page].class
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    @posts = get_post_subset(first_page,SECONDARY_ITEMS_PER_PAGE,filter)
 
    render 'list', locals: { posts: @posts, subset: filter, title: get_title(filter), icon: get_icon(filter)}
  end

  # GET /posts
  # GET /posts.json
  def index
  #  @users = User.as(:t).where('true = true WITH t ORDER BY t.first_name, t.last_name desc')
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    puts "post_params[:is_owned_by]: #{post_params[:is_owned_by]}"
    is_owned_by = post_params[:is_owned_by].split(":")
    @current_owner_class = is_owned_by[0]
    @current_owner_uuid = is_owned_by[1]
    params[:post].delete("is_owned_by")
    @post = Post.new(post_params)

    @current_owner = Neo4j::Session.query("match (dest:#{@current_owner_class} { uuid : '#{@current_owner_uuid}' }) return dest").first[0]

    puts "Owner class is: #{@current_owner.class.name}, #{@current_owner}"

    respond_to do |format|
      if @post.save
        rel = Owns.create(from_node: current_user, to_node: @post)
        rel = PostBelongsTo.create(from_node: @post, to_node: @current_owner)

        format.js   { render partial: "enqueue", object: @post, locals: { :current_owner => @current_owner }, notice: 'Post was successfully created.' }
        format.html { redirect_to(request.env["HTTP_REFERER"]) }
        format.json { render :show, status: :created, location: @post, user: @post.is_owned_by }
      else
        format.js   { render :new, object: @post, locals: { :current_owner => @current_owner } }
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.js   { render partial: "replace", object: @post, notice: 'Post was successfully created.' }
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.js   { render :edit, object: @post }
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    dest = @post.uuid
    @post.destroy
    respond_to do |format|
      format.js   { render partial: "shared/remove", locals: { dest: dest } }
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_current_user
     current_user
  end

  # GET /posts/list/:filter(/:limit(/:subject))
  def get_post_subset(actual_page, items_per_page, filter)
    puts "INTO  - (postsController) get_subset"
    query_string = prepare_query(filter)

    puts "post - get subset - query string: #{query_string}"
    post = Post.as(:posts).query.match(query_string).proxy_as(Post, :posts).paginate(:page => actual_page, :per_page => items_per_page, return: :posts, order: "posts.created_at desc")
    puts "get_subset count: #{post.count} - class: #{post.class.name} - #{post}"
    post
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :title, :is_owned_by, :user)
    end
end
