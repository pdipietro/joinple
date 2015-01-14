class SocialNetworksController < ApplicationController
  before_action :set_social_network, only: [:show, :edit, :update, :destroy]

  respond_to :js

  # GET /social_networks
  # GET /social_networks.json
  def index
    @social_networks = SocialNetwork.all.order(created_at:  :desc)
    respond_to do |format|
        format.js
    end
  end

  # GET /social_networks/1
  # GET /social_networks/1.json
  def show
  end

  # GET /social_networks/new
  def new
    @social_network = SocialNetwork.new
      respond_to do |format|
        format.js
    end
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
        rel = Owns.create(from_node: current_user, to_node: @social_network) 
        format.js   { render partial: "insert", object: @social_network, notice: 'Language was successfully created.' }
        format.html { redirect_to @social_network, notice: 'Social network was successfully created.' }
        format.json { render :show, status: :created, location: @social_network }
      else
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
        format.html { redirect_to @social_network, notice: 'Social network was successfully updated.' }
        format.json { render :show, status: :ok, location: @social_network }
      else
        format.html { render :edit }
        format.json { render json: @social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_networks/1
  # DELETE /social_networks/1.json
  def destroy
    @social_network.destroy
    respond_to do |format|
      format.html { redirect_to social_networks_url, notice: 'Social network was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_network
      @social_network = SocialNetwork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_network_params
      params.require(:social_network).permit(:name, :description, :goals)
    end
end
