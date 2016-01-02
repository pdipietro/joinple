class SocialNetworksController < ApplicationController
  before_action :set_social_network, only: [:show, :edit, :update, :destroy]
  
  include SocialNetworksHelper

  require 'neo4j-will_paginate_redux'

  respond_to :js

  BASIC_ITEMS_PER_PAGE = 25
  SECONDARY_ITEMS_PER_PAGE = 25

 # def list_one
 #   logger.debug ("--- Social Network Controller: List_one --(#{params[:filter]})--")
 # end

  # GET /social_network/list/:filter(/:limit(/:subject))
  def list
    logger.debug ("--- Social Network Controller: List --(#{params[:filter]})--")

    first_page = params[:from_page].nil? ? 1 : params[:from_page]

    filter = params[:filter]
    query_string = build_filter(current_subject_id?,filter)

    @social_networks = SocialNetwork.as(:social_networks).query.match(query_string).proxy_as(SocialNetwork, :social_networks).paginate(:page => first_page, :per_page => SECONDARY_ITEMS_PER_PAGE, return: :social_networks, order: "social_networks.created_at desc")

    # patch if user just signed, there is still no social he participate so view all  
    if filter == "iparticipate" && @social_networks.count == 0
      query_string = build_filter(current_subject_id?,"all")
      @social_networks = SocialNetwork.as(:social_networks).query.match(query_string).proxy_as(SocialNetwork, :social_networks).paginate(:page => first_page, :per_page => SECONDARY_ITEMS_PER_PAGE, return: :social_networks, order: "social_networks.created_at desc")
    end

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
    logger.debug  ("----- Groups Controller: show --")
    @show = true
    list_one
  end

  # GET /social_networks/new
  def new
    @social_network = SocialNetwork.new
  end

  # GET /social_networks/1/edit
  def edit
    #debugger
  end

  # POST /social_networks
  # POST /social_networks.json
  def create
    logger.debug ("----- SocialNetworks Controller: Create --------------")
    @social_network = nil
    success = true

    begin
      tx = Neo4j::Transaction.new
        debugger
        @social_network = SocialNetwork.new(social_network_params)

        #@social_network.logo = cloudinary_clean(@social_network.logo)
        #@social_network.banner = cloudinary_clean(@social_network.banner)

        x = @social_network.save
       
        rel = Owns.create(from_node: current_subject, to_node: @social_network) 

        logo = Image.new [{uuid: social_network_params[:logo], type: :logo}]
        banner = Image.new [{uuid: social_network_params[:banner], type: :banner}]

        rel_logo = HasImage.create(from_node: @social_network, to_node: logo)
        rel_banner = HasImage.create(from_node: @social_network, to_node: image)

      rescue => e
        tx.failure
        success = false
      ensure
        tx.close

      respond_to do |format|
        unless success 
          logger.debug "--------- /SocialNetwork/create: transaction failure: #{@social_network.uuid?} - event: #{e}"
          format.js   { render partial: "enqueue", object: @social_network, notice: 'Social network was successfully created.' }
          format.html { redirect_to @social_network, notice: 'Social network was successfully created.' }
          format.json { render :show, status: :created, location: @social_network }
        else
          logger.debug "--------- /SocialNetwork/create: transaction succeeded: #{@social_network.name}"
          format.js   { render :new, object: @social_network }
          format.html { render :new, object: @social_network }
          format.json { render json: @social_network.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /social_networks/1
  # PATCH/PUT /social_networks/1.json
  def update
   #debugger
    parms = social_network_params
    parms[:logo] = cloudinary_clean(parms[:logo]) unless parms[:logo].to_s.length == 0
    parms[:banner] = cloudinary_clean(parms[:banner])unless parms[:banner].to_s.length == 0
    logger.debug  "parms: #{parms}"

    respond_to do |format|
      if @social_network.update(parms)
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
    logger.debug  "INTO  - get_social_network_subset"
    query_string = prepare_query(filter)
    logger.debug  "query_string: #{query_string}"
    sn = SocialNetwork.as(:social_networks).query.match(query_string).proxy_as(SocialNetwork, :social_networks).paginate(:page => actual_page, :per_page => items_per_page, return: :social_networks, order: "social_networks.created_at desc")
    logger.debug  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    logger.debug  "#{sn}"
    logger.debug  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    sn
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_network
      @social_network = SocialNetwork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_network_params
      params.require(:social_network).permit(:uuid, :name, :description, :short_description, :goal, :slogan, :logo, :banner, :status, :is_visible, :is_online, :background_color, :text_color, :social_network_color)
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
