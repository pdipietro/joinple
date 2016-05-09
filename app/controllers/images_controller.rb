class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

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
    connections, cloudinary = form_data
    @image = Image.new(image_params)
    splat(@image, 'images_controller:create')
    
    self_direction = nil 
    parent = nil
    name = nil

    owner_name = nil
    owner_id = nil
    owner = nil

    connections.each do |conn|
      if conn['from'] == :self
        self_direction = :out
        parent = conn['to']
        name = conn['rel_revname']
      else
        self_direction = :in
        parent = conn['from']
        name = conn['rel_name']
      end
      history = conn['history']
      object = conn['rel_object']

      conn['from'].each do |key, val|
        owner_name = key
        owner_id = val['id']
      end

      splat(connections, 'images_controller:create - connections')
      splat(cloudinary, 'images_controller:create - cloudinary')
      splat(@image, 'images_controller:create - image')

      failed = :false

      begin
        tx = Neo4j::Transaction.new

        old_rel = owner_name.classify.constantize.as(:o).where(uuid: owner_id).has_image(:i, :r).where("r.object = ?",object).pluck(:o,:r,:i)
        owner = owner_name.classify.constantize.as(:o).where(uuid: owner_id).pluck(:o)[0]

        if old_rel == []
          # @image = Image.find(uuid: image.uuid)
          newRel = HasImage.create(owner, @image, object: object) 
        else
          oldImage = old_rel[0][2]
          del = old_rel[0][1].destroy
          newRel = HasImage.create(owner, @image, object: object) 
          if history
            newHistory = HasHistory.create(@image, oldImage)                   
          end
        end

      rescue => e
        logger.debug "Transaction failed: #{e}"
        puts e.backtrace
        puts "Error during processing: #{$!}"
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        failed = :true
        tx.failure
        raise
      ensure
        tx.close
      end
    end

    jpl_parms = ImagesHelper.update(@image,cloudinary,connections)  
    render 'forms/update', format: :js, locals: {jpl_parms: jpl_parms, parms: params} and return
  end

  def update
    splat(image_params, 'images_controller:update')
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
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

  def storify(cloudinary,connections)
  end
end
