module SubjectProfilesHelper
  def self.show(subject_profile) 
    subject = subject_profile.belongs_to

    h = {
      :subject_profile => {
          :subject_profile => subject_profile,
          :subject => subject
        }
      } 
    h
  end

  def self.update(subject_profile) 
    self.show(subject_profile)
  end

  def self.edit_s_sp_i(subject_profile) 
    subject = subject_profile.belongs_to
    photo = subject_profile.has_image
    photo = Image.new if photo.nil?

    h = {
      :subject_profile => {
        :subject_profile => subject_profile,
        :subject => subject
      },
      :image => {
        :image => photo,
        :subject_profile => subject_profile,
        :cloudinary => {
          :preset => "subject_photo",
          :page_header => I18n.translate('subject_profile.view.photo.header', operation: I18n.t('operation.edit'), full_name: subject.full_name ), 
          :folder => "subject/#{subject.uuid}"
        },
        :connections => [{
          :from => subject_profile,
          :rel_name => :has_image,
          :rel_revname => :is_image_of,
          :rel_object => :photo,
          :to => :self,
          :history => :true
        }]
      }
    } 

    h
  end
end
