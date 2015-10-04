class SubjectProfilesController < ApplicationController
  before_action :set_subject_profile, only: [:show, :edit, :update, :destroy]

  respond_to :js

  def show
  end

  # GET /subject_profiles/1/edit
  def edit
  end

  # PATCH/PUT /subject_profiles/1
  # PATCH/PUT /subject_profiles/1.json
  def update
      parms = subject_profile_params
      parms[:photo] = cloudinary_clean(parms[:photo])
    if @subject_profile.update(parms)
       puts ("E' andato bene: #{subject_profile_params}")
       flash[:success] = "Profile updated"
       redirect_to @subject_profile
    else
       puts ("E' andato male: #{subject_profile_params}")
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
