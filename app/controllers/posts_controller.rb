class PostsController < ApplicationController
  before_action :check_social_network
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_subject, only: [:index, :create, :destroy]
  #before_action :set_images, only: [:create] 

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
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:follows]->(f:Subject)-[follows]->"
        when "iprefere"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:preferes]->"
        when "iparticipate"
              "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:participates|owns|admins]->"
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
    # @post = Post.new
    # @post.uuid = SecureRandom::uuid

  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create

    @post = Post.new(post_params)

    @post.image0 = cloudinary_clean(@post.image0) unless @post.image0.nil?
    @post.image1 = cloudinary_clean(@post.image1) unless @post.image1.nil?  
    @post.image2 = cloudinary_clean(@post.image2) unless @post.image2.nil? 
    @post.image3 = cloudinary_clean(@post.image3) unless @post.image3.nil?  
    @post.image4 = cloudinary_clean(@post.image4) unless @post.image4.nil?  

    respond_to do |format|
      begin
        tx = Neo4j::Transaction.new
          @post.save
          puts "posts error: #{@post.errors}"
          rel = Owns.create(from_node: current_subject, to_node: @post)
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
          format.json { render :show, status: :created, location: @post, subject: @post.is_owned_by }
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

  def get_current_subject
     current_subject
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
      params.require(:post).permit(:content, :uuid, :image0, :image1, :image2, :image3, :image4 )
    end

    def set_images 
      t = @post.image
      @post.image.clear
      t.each do |arr|
        @post.image << arr unless arr.nil?;
      end
    end

=begin
    def old_set_images (post)
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
=end

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

