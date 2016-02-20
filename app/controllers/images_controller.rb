class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  #before_action :get_form_data, only: [:create]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  def create
    debugger
    connections, cloudinary = form_data
    splat(image_params, 'images_controller:create')
    splat(connections, 'images_controller:create')
    splat(cloudinary, 'images_controller:create')
    begin
      tx = Neo4j::Transaction.new
      image_params[:cloudinary_id] = cloudinary_clean(image_params[:cloudinary_id])
      @image = Image.new(image_params)

      @image.cloudinary_id = cloudinary_clean(@image.cloudinary_id)

      @image.save
      # manage image history, if any
      if image_params[:rel][:history]
        unless @image.previous.nil?
  #        old_image = @image.previous
  #        rel = HasImage.create(from_node: image_params[:from_node], to_node: @image, properties: { type: image_params[:type]}) 
  #        new_rel = 
        end
      end

    rescue => e
      tx.failure
    ensure
      tx.close
    end

    jpl_parms = ImagesHelper.update(@image,params[:cloudinary],params[:connections])
    render 'forms/update', format: :js, locals: {jpl_parms: jpl_parms, parms: params} and return
  end

  def update
    splat(image_params, 'images_controller:update')
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
  debugger
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def image (object, type)

  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:uuid, :cloudinary_id)
    end

    def get_form_data
      form_parms = form_data
    end

    def sclean_params
      debugger
      p = image_params
      @image = p[:image]
      @cloudinary = p[:image][:cloudinary]
      @params = p[:image][:params]
    end
end