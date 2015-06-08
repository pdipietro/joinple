class PostsController < ApplicationController
  before_action :check_social_network
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :create, :destroy]

  respond_to :js

  # GET /post/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Post Controller: List --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    social_uuid = params[:social_uuid]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    basic_query = "(posts:Post)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{social_uuid}'} ) "

    qstr =
      case filter
        when "ifollow"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:follows]->(f:User)-[follows]->"
        when "iprefere"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:preferes]->"
        when "iparticipate"
              "(user:User { uuid : '#{current_user.uuid}' })-[p:participates|owns|admins]->"
        when "all"
              ""
        else 
             ""      
       end

    query_string = qstr << basic_query

    puts "---------------- Query: #{query_string}"

    @posts = Post.as(:posts).query.match(query_string).proxy_as(Post, :posts).paginate(:page => first_page, :per_page => secondary_items_per_page, return: "posts", order: "posts.created_at desc")

puts "=============================================================================================="
    @posts.each do |post|
      puts post.content
    end
puts "=============================================================================================="

    render 'list', locals: { posts: @posts, subset: filter, title: get_title(filter)}

  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      begin
        tx = Neo4j::Transaction.new
          @post.save
          puts "posts error: #{@post.errors}"
          rel = Owns.create(from_node: current_user, to_node: @post)
          puts "Owns.create: #{rel.errors}"
          #rel = BelongsTo.create(from_node: @post, to_node: current_social_network)
          rel = @post.create_rel("belongs_to", current_social_network)  
        rescue => e
          tx.failure
          puts "--------- /post/create: transaction failure: #{@post.content}, #{@post.image}"
          format.js   { render :new, object: @post }
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        ensure
          tx.close
          format.js   { render partial: "enqueue", object: @post, notice: 'Post was successfully created.' }
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.json { render :show, status: :created, location: @post, user: @post.is_owned_by }
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
      params.require(:post).permit(:content, :image0, :image1, :image2, :image3, :image4, :hidden_image0, :hidden_image1, :hidden_image2, :hidden_image3, :hidden_image4 )
    end

    def set_images (post)
      i = 0
      arrs = post.arrs
      post.image0 = post.image1 = post.image2 = post.image3 = post.image4 = ""
      arrs.each do |arr|
        puts "Arr: #{arr}"
        x = "post.image#{i}"
        i = i + 1
        eval (x)       
      end
      arrs = []
    end

    def get_title(filter)
        case filter
          when "ifollow"
                "My following posts"
          when "iparticipate"
                "My posts"
          when "iprefere"
                "My preferred posts"
          when "all"
                "All posts"
          else 
               "All posts"      
        end
    end


end

