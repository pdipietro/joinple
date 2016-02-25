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
    splat(image_params, 'images_controller:create')
    
    self_direction = nil 
    parent = nil
    name = nil

    owner_name = nil
    owner_id = nil

    k = {'from'=>{'subject_profile'=>{'id'=>'cab3c913-1209-4a5a-b1d7-3f751a81cb41'}}, 
        'rel_name'=>'has_image', 
        'rel_revname'=>'is_image_of', 
        'rel_type'=>'photo', 
        'to'=>'self', 
        'history'=>'true'
      }

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
      type = conn['reltype']

      k['from'].each do |key, val|
        owner_name = key
        owner_id = val['id']
      end

      splat(connections, 'images_controller:create - connections')
      splat(cloudinary, 'images_controller:create - cloudinary')

      debugger
      sp = Object.const_set(owner_name.classify,Class.new)
      #query_string = "(oldImg:Image)<-[old_rel:has_image]-(owner:#{owner_name.classify} { uuid : '#{owner_id}'})"
      query_string = "-[old_rel:has_image]->(oldImg:Image)"
      @sp = sp.as(:owners).query.match(query_string).proxy_as(Owner, :owners).return(:owners)
      
      x = @sp.has_image.nil?

      sp = Neo4j::Session.query.match("(owner:#{owner_name.classify} { uuid : '#{owner_id}'})").return(:owner).first           
      query_string = "(owner:#{owner_name.classify} { uuid : '#{owner_id}'})-[old_rel:has_image]->(oldImg:Image)"
      dest = nil

      #old_rel = HasImage.new
      old_rel = Neo4j::Session.query.match(query_string).return(:old_rel).first
      debugger
      #begin
        #tx = Neo4j::Transaction.new
        @image = Image.new
        @image.cloudinary_id = cloudinary_clean(params[:full_cloudinary_id])
        @image.save

        if old_rel.nil?
          newRel = HasImage.create(owner, @image, type: type) 
        else
          owner = old_rel.from
          oldImage = old_rel.to
          old_rel.delete
          newRel = HasImage.create(owner, @image, type: type) 
          if history
            newHistory = HasHistory.create(@image, oldImage)                   
          end
        end

      #rescue => e
      #  logger.debug "Transaction failed: #{e}"
      #  tx.failure
        jpl_parms = ImagesHelper.update(@image,cloudinary,connections)  
      #ensure
      #  tx.close
      #  jpl_parms = ImagesHelper.update(@image,cloudinary,connections)  
      #end
    end

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
    params.require(:image).permit(:uuid, :full_cloudinary_id)
  end

  def storify(cloudinary,connections)
  end
end
