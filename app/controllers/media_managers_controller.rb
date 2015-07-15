class MediaManagersController < ApplicationController
  before_action :set_media_manager, only: [:show, :edit, :update, :destroy]

  before_action :check_social_network
 # before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_subject, only: [:create, :destroy]

  respond_to :js

  # GET /media_managers
  # GET /media_managers.json
  def list
    @media_managers = MediaManager.new
    reset_current_group  

    filter = params[:filter]
    q = prepare_query(filter)
    puts params[:from_page].class
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    @groups = get_group_subset(first_page,SECONDARY_ITEMS_PER_PAGE,filter)
 
    render 'list', locals: { groups: @groups, subset: filter, title: get_title(filter), icon: get_icon(filter)}

  end

  # GET /media_managers
  # GET /media_managers.json
  def index

    filter = params[:filter]
    puts ("filter: #{filter}")
    selected_obj = filter[3]
    @media_manager = selected_obj.constantize.new

  end

  # GET /media_managers/1
  # GET /media_managers/1.json
  def show
    filter = params[:id]
    puts ("filter: #{filter}")
    selected_obj = ImageSizes::images(:id)
    @media_manager = selected_obj.constantize.new
  end

  # GET /media_managers/new
  def new
    @media_manager = MediaManager.new
  end

  # GET /media_managers/1/edit
  def edit
  end

  # POST /media_managers
  # POST /media_managers.json
  def create
    @media_manager = MediaManager.new(media_manager_params)

    respond_to do |format|
      if @media_manager.save
        format.html { redirect_to @media_manager, notice: 'Media manager was successfully created.' }
        format.json { render :show, status: :created, location: @media_manager }
      else
        format.html { render :new }
        format.json { render json: @media_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media_managers/1
  # PATCH/PUT /media_managers/1.json
  def update
    respond_to do |format|
      if @media_manager.update(media_manager_params)
        format.html { redirect_to @media_manager, notice: 'Media manager was successfully updated.' }
        format.json { render :show, status: :ok, location: @media_manager }
      else
        format.html { render :edit }
        format.json { render json: @media_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media_managers/1
  # DELETE /media_managers/1.json
  def destroy
    @media_manager.destroy
    respond_to do |format|
      format.html { redirect_to media_managers_url, notice: 'Media manager was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_manager
      @media_manager = MediaManager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_manager_params
      params[:media_manager]
    end
end

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def get_media_manager_subset(actual_page, items_per_page, filter)
    puts "INTO  - (GroupsController) get_subset"
    query_string = prepare_query(filter)

    puts "group - get subset - query string: #{query_string}"
    grp = Image.as(:images).query.match(query_string).proxy_as(media_maneger, :mediaManagers).paginate(:page => actual_page, :per_page => items_per_page, return: :groups, order: "groups.created_at desc")
    puts "get_subset count: #{grp.count} - class: #{grp.class.name} - #{grp}"
    grp
  end
