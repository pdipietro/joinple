class SocialNetworksController < ApplicationController
  before_action :set_social_network, only: [:show, :edit, :update, :destroy]
  
  require 'neo4j-will_paginate_redux'

  respond_to :js

  BASIC_ITEMS_PER_PAGE = 25
  SECONDARY_ITEMS_PER_PAGE = 25


  # GET /social_network/list/:filter(/:limit(/:subject))
  def list
    puts ("----- Social Network Controller: List --(#{params[:filter]})----------------------------------------")

    filter = params[:filter]
    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    puts "current_subject: #{current_subject} - current_subject.uuid: #{current_subject.uuid}"


    query_string =
      case filter
        when "iparticipate"
             "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:participates|owns]->(social_networks:SocialNetwork)"
        when "iadminister"
             "(subject:Subject { uuid : '#{current_subject.uuid}' })-[p:owns]->(social_networks:SocialNetwork)" 
        when "all"
             "(social_networks:SocialNetwork)"
      end

    @social_networks = SocialNetwork.as(:social_networks).query.match(query_string).proxy_as(SocialNetwork, :social_networks).paginate(:page => first_page, :per_page => SECONDARY_ITEMS_PER_PAGE, return: :social_networks, order: "social_networks.created_at desc")

    render 'list', locals: { social_networks: @social_networks, subset: filter, title: get_title(filter)}
  end

=begin
  # GET /social_network
  def index
    filter = "iparticipate"
    @social_networks = get_social_network_subset(1,BASIC_ITEMS_PER_PAGE,filter)

    render 'index', locals: { social_networks: @social_networks, subset: filter, title: get_title(filter)}
  end
=end

  # GET /social_networks
  # GET /social_networks.json
  def index
     @social_networks = SocialNetwork.all.order(created_at:  :desc)
  end

  # GET /social_networks/1
  # GET /social_networks/1.json
  def show
    @social_network = SocialNetwork.find
  end

  # GET /social_networks/new
  def new
    @social_network = SocialNetwork.new
  end

  # GET /social_networks/1/edit
  def edit
  end

  # POST /social_networks
  # POST /social_networks.json
  def create
    @social_network = SocialNetwork.new(social_network_params)

    respond_to do |format|
      if @social_network.save
        rel = Owns.create(from_node: current_subject, to_node: @social_network) 

        format.js   { render partial: "enqueue", object: @social_network, notice: 'Social network was successfully created.' }
        format.html { redirect_to @social_network, notice: 'Social network was successfully created.' }
        format.json { render :show, status: :created, location: @social_network }
      else
        format.js   { render :new, object: @social_network }
        format.html { render :new }
        format.json { render json: @social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /social_networks/1
  # PATCH/PUT /social_networks/1.json
  def update
    respond_to do |format|
      if @social_network.update(social_network_params)
        format.js   { render partial: "replace", object: @social_network, notice: 'Social network was successfully updated.' }
        format.html { redirect_to @social_network, notice: 'Social network was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_network }
      else
        format.js   { render :edit, object: @social_network }
        format.html { render :edit }
        format.json { render json: @social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_networks/1
  # DELETE /social_networks/1.json
  def destroy
    dest = @social_network.uuid
    @social_network.destroy
    respond_to do |format|
      format.js   { render partial: "shared/remove", locals: { dest: dest } }
      format.html { redirect_to social_networks_url, notice: 'Social network was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ################################ HELPERS METHODS ##########################

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def get_social_network_subset(actual_page, items_per_page, filter)
    puts "INTO  - get_social_network_subset"
    query_string = prepare_query(filter)
    puts "query_string: #{query_string}"
    sn = SocialNetwork.as(:social_networks).query.match(query_string).proxy_as(SocialNetwork, :social_networks).paginate(:page => actual_page, :per_page => items_per_page, return: :social_networks, order: "social_networks.created_at desc")
    #grp = Group.as(:groups).query.match(query_string).proxy_as(Group, :groups).paginate(:page => actual_page, :per_page => items_per_page, return: :groups, order: "groups.created_at desc")
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "#{sn}"
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    sn
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_network
      @social_network = SocialNetwork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_network_params
      params.require(:social_network).permit(:name, :description, :short_description, :mission, :slogan, :logo, :banner, :background_color, :text_color, :social_network_color)
    end

    def get_title(filter)
      case filter
        when "iparticipate"
              "My social networks"
        when "iadminister"
              "Social networks I administer"
        when "mycontacts"
              "My contact's social networks"
        when "search"
              ""
        when "all"
              "All social networks"
        else 
             "Social networks"      
      end
    end

end
