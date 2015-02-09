class GroupsController < ApplicationController

  include GroupsHelper

  before_action :check_social_network
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :destroy]

  respond_to :js

=begin
  
  # GET /groups/list/:filter(/:limit(/:subject))
  def right_list
    @groups = []
    @title = []

    SECONDARY_SUBSET.each do |subset|
      @groups << get_subset(subset,SECONDARY_ITEMS_PER_PAGE )
      @title << get_title(subset)
    end
  end
=end

  # GET /groups/list/:filter(/:limit(/:subject))
  def list
    @title = []

    filter = params[:filter]
    puts params[:from_page].class
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

     @groups = get_subset(first_page,SECONDARY_ITEMS_PER_PAGE,filter)
 
    render 'list', locals: { groups: @groups, subset: filter, title: get_title(filter), icon: get_icon(filter)}
  end

  # GET /groups
  # GET /groups.json
  def index
    #@groups = Group.all.order(created_at:  :desc)
    filter = "iparticipate"

    @groups = get_subset(1,BASIC_ITEMS_PER_PAGE,filter)

    render 'index', locals: { groups: @groups, subset: filter, title: get_title(filter), icon: get_icon(filter)}
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
#    @groups = Group.find(@id)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        rel = Owns.create(from_node: current_user, to_node: @group)
        rel = BelongsTo.create(from_node: @group, to_node: current_social_network)
        format.js   { render partial: "enqueue", object: @group, notice: 'Group was successfully created.' }
        format.html { redirect_to(request.env["HTTP_REFERER"]) }
        format.json { render :show, status: :created, location: @group }
      else
        format.js   { render :new, object: @group }
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.js   { render partial: "replace", object: @group, notice: 'Group was successfully created.' }
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.js   { render :edit, object: @group }
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    dest = @group.uuid
    @group.destroy
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
      params.require(:group).permit(:name, :description, :is_open, :is_private, :image, :icon, :color)
    end
end
