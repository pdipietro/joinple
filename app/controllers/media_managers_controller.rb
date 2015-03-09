class MediaManagersController < ApplicationController
  before_action :set_media_manager, only: [:show, :edit, :update, :destroy]

  # GET /media_managers
  # GET /media_managers.json
  def index
    @media_managers = MediaManager.all
  end

  # GET /media_managers/1
  # GET /media_managers/1.json
  def show
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
