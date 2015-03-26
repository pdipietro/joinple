class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:edit]
  before_action :set_local_user_profile, only: [:update]
  after_action  :set_current_user_profile, only: [:update]    # update the user profile in session

  respond_to :js

  # GET /user_profiles/1/edit
  def edit
  end

  # PATCH/PUT /user_profiles/1
  # PATCH/PUT /user_profiles/1.json
  def update
    respond_to do |format|
      if @user_profile.update(user_profile_params)
        puts "userprofile after .update #{@user_profile} "
        format.js   { render "edit", object: @user_profile, notice: 'User profile was successfully updated.' }
        format.html { redirect_to @user_profile, notice: 'User profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_profile }
      else
        format.js   { render :edit, object: @user_profile }
        format.html { render :edit }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_profile
      puts "1) current_user.uuid: #{current_user.uuid}"
      @user_profile = UserProfile.find_by_user current_user.uuid # params[:id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_local_user_profile
      puts "2) current_user.uuid: #{params[:id]} - #{params}"
      @user_profile = UserProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_profile_params
      params.require(:user_profile).permit(:photo, :description, :background_color, :text_color, :photo_cache)
    end
end
