class SubjectProfilesController < ApplicationController
	before_action :set_subject_profile, only: [:show, :edit, :update, :destroy]

	respond_to :js

	def show

	end
	# GET /subject_profiles/1/edit

	def edit
		logger.debug "----------------------------------------------------------------------"
		logger.debug "params: #{params}"
		params.each do |p,v|
			logger.debug "#{p}: #{v}"
		end
		logger.debug "params[:uuid] = #{params[:uuid]} - #{params[:id]}"
		@subject_profile = SubjectProfile.find_by(id: params[:id])

		logger.debug "@subject_profile = #{@subject_profile.uuid}"

		@photo = @subject_profile.has_image(:i, :r).where("r.type = {photo}").params(photo: "photo").first(:i)

		logger.debug "@photo = #{@photo.uuid}"
		logger.debug "----------------------------------------------------------------------"

		render "edit", locals: { :subject_profile => @subject_profile, :photo => @photo}	
	end

	# PATCH/PUT /subject_profiles/1
	# PATCH/PUT /subject_profiles/1.json
	def supdate
			parms = subject_profile_params
			parms[:photo] = cloudinary_clean(parms[:photo])
		if @subject_profile.update(parms)
			 flash[:success] = "Profile updated"
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

	def update
		logger.debug ("----- SubjectProfile Controller: Update #{@subject_profile}--------------")
		success = true

		begin
			tx = Neo4j::Transaction.new
				@subject_profile.update(subject_profile_params)

#				parms[:photo] = cloudinary_clean(parms[:photo])
#				@photo.update(subject_profile_params[:photo], type: "photo")
#				rel = HasImage.create(from_node: @subject_profile, to_node: @Image) 

			rescue => e
				tx.failure
				success = false
			ensure
				tx.close

			respond_to do |format|
				if success 
					logger.debug "--------- /SubjectProfile/update: transaction failure: #{@subject_profile.uuid?} - event: #{e}"
					format.js   { render :replace, object: @subject_profile, notice: 'Subject profile was successfully updated.' }
					format.html { redirect_to @subject_profile, notice: 'Subject profile was successfully updated.' }
					format.json { render :show, status: :ok, location: @subject_profile }
				else
					logger.debug "--------- /SubjectProfile/update: transaction succeeded: #{@subject_profile.uuid?}"
					flash[:success] = "Profile updated"
					redirect_to @subject_profile

		#      format.js   { render :edit, object: @subject_profile, locals: { :photo => @photo} }
		#      format.html { render :edit }
		#      format.json { render json: @subject_profile.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_subject_profile
			@subject_profile = SubjectProfile.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def subject_profile_params
			#params[:subject_profile]
			params.require(:subject_profile).permit(:photo, :description, :background_color, :text_color) 
		end
end
