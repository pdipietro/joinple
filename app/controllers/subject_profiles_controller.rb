class SubjectProfilesController < ApplicationController
  include SubjectProfilesHelper
  before_action :check_social_network
  before_action :set_subject_profile, only: [:show, :edit, :update, :destroy]
  respond_to :js

  # GET /subject_profiles/1/show
  def show
    splat(@subject_profile, 'subject_profiles_controller:show')
    jpl_parms = SubjectProfilesHelper.show(@subject_profile)
    render 'forms/show', format: :js, locals: {jpl_parms: jpl_parms, parms: params}
  end

  # GET /subject_profiles/1/edit
  def edit
    splat(@subject_profile, 'subject_profiles_controller:edit')
    jpl_parms = SubjectProfilesHelper.edit_s_sp_i(@subject_profile)
    render 'forms/edit', format: :js, locals: {jpl_parms: jpl_parms, parms: params}
  end

  # PATCH/PUT /subject_profiles/1
  # PATCH/PUT /subject_profiles/1.json
  def update
    splat(subject_profile_params, 'subject_profiles_controller:update')
    begin
      tx = Neo4j::Transaction.new
      @subject_profile.update(subject_profile_params)
    rescue => e
      tx.failure
    ensure
      tx.close
    end

    jpl_parms = SubjectProfilesHelper.update(@subject_profile)
    render 'forms/update', format: :js, locals: {jpl_parms: jpl_parms, parms: params}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject_profile
    @subject_profile = SubjectProfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subject_profile_params
    # params[:subject_profile]
    params.require(:subject_profile).permit(:id, :uuid, :description, :background_color, :text_color)
  end

#  def show_edit
#    splat(params, 'subject_profiles_controller:show_edit')##
#
#    @subject_profile = SubjectProfile.find_by(id: params[:id])
#    evline = "SubjectProfilesHelper.#{params[:action]}_s_sp_i(@subject_profile)"
#    jpl_parms = eval evline
#    splat(jpl_parms, 'edit_s_sp_i')
#    jpl_parms
#    render "forms/show", format: :js, locals: {jpl_parms: jpl_parms, parms: params}
#  end
end
