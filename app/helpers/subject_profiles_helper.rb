module SubjectProfilesHelper
  def self.show(subject_profile) 
    subject = subject_profile.belongs_to
    image = subject_profile.has_image
    image = Image.new if image.nil?

    h = {
      :subject_profile => {
        :subject_profile => subject_profile,
        :subject => subject,
        :image => image
        }
      } 
  end

  def self.update(subject_profile) 
    self.show(subject_profile)
  end

  def self.edit_s_sp_i(subject_profile) 
    #debugger
    subject = subject_profile.belongs_to
    image = subject_profile.has_image
    image = Image.new if image.nil?

    h = {
      :subject_profile => {
        :subject_profile => subject_profile,
        :subject => subject,
        :image => image
      },
      :image => {
        :image => image,
        :owner => subject_profile,
        :cloudinary => {
          :preset => "subject_photo",
          :page_header => I18n.translate('subject_profile.view.photo.header', operation: I18n.t('operation.edit'), full_name: subject.full_name ), 
          :folder => "subject/#{subject.uuid}"
        },
        :connections => [{
          :from => subject_profile,
          :rel_name => :has_image,
          :rel_revname => :is_image_of,
          :rel_object => :image,
          :to => :self,
          :history => :true
        }]
      }
    } 
  end
end
