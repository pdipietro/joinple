class SubjectProfilesController < ApplicationController
  before_action :check_social_network
  before_action :set_subject_profile, only: %i(:show :edit :update :destroy)

  respond_to :js

  # GET /subject_profiles/1/show
  def show
    show_edit and return
  end

  # GET /subject_profiles/1/edit
  def edit
    show_edit and return
  end

  # PATCH/PUT /subject_profiles/1
  # PATCH/PUT /subject_profiles/1.json
  def update
    parms = subject_profile_params
    parms[:photo] = cloudinary_clean(parms[:photo])
    if @subject_profile.update(parms)
      flash[:success] = 'Profile updated'
      redirect_to @subject_profile
    else
      render :edit, object: @subject_profile
    end
  #  respond_to do |format|
  #    if @subject_profile.update(subject_profile_params)
  #      format.js { render :replace, object: @subject_profile, notice: 'Subject profile was successfully updated.' }
  #      format.html { redirect_to @subject_profile, notice: 'Subject profile was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @subject_profile }
  #    else
  #      format.js { render :edit, object: @subject_profile }
  #      format.html { render :edit }
  #      format.json { render json: @subject_profile.errors, status: :unprocessable_entity }
  #    end
  #  end
  end

  def updates
    logger.debug "----- SubjectProfile Controller: Update #{@subject_profile}"
    success = true

    begin
      tx = Neo4j::Transaction.new
      @subject_profile.update(subject_profile_params)

      # parms[:photo] = cloudinary_clean(parms[:photo])
      # @photo.update(subject_profile_params[:photo], type: "photo")
      # rel = HasImage.create(from_node: @subject_profile, to_node: @Image)

    rescue => e
      tx.failure
      success = false
    ensure
      tx.close
    end

    respond_to do |format|
      if success
        logger.debug "--------- /SubjectProfile/update: transaction failure: #{@subject_profile.uuid?} - event: #{e}"
        format.js   { render :replace, object: @subject_profile, notice: 'Subject profile was successfully updated.' }
        format.html { redirect_to @subject_profile, notice: 'Subject profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject_profile }
      else
        logger.debug "--------- /SubjectProfile/update: transaction succeeded: #{@subject_profile.uuid?}"
        flash[:success] = 'Profile updated'
        redirect_to @subject_profile

        # format.js   { render :edit, object: @subject_profile, locals: { :photo => @photo} }
        # format.html { render :edit }
        # format.json { render json: @subject_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject_profile
    debugger
    @subject_profile = SubjectProfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subject_profile_params
    # params[:subject_profile]
    params.require(:subject_profile).permit(:photo, :description, :background_color, :text_color)
  end

  def show_edit
    logger.debug '===================================================================================='
    logger.debug "------- SubjectProfilesController:#{params[:action]}"
    logger.debug "current_social_network.class.name: #{current_social_network.class.name}"
    logger.debug current_social_network.to_s
    params.each do |p, v|
      logger.debug "#{p}: #{v}"
    end
    @subject_profile = SubjectProfile.find_by(id: params[:id])
    tag = params[:action] == 'show' ? '#full-screen-image' : '#full-screen-image-edit'
    render 'forms/edit', format: :js, locals: { object: @subject_profile, form: params[:action], tag: tag }
  end
end
