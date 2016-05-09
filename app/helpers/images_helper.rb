module ImagesHelper

  def self.update(image, cloudinary, connections) 
    owner = image.is_image_of
    h = {
      :image => {
          :image => image,
          :owner => owner,
          :cloudinary => cloudinary,
          :connections => connections
        }
      } 
    h
  end

  IMAGE_KIND =
    {
    discussion_banner: {
      preset_name: 'discussion-banner',
      theme: 'default',
      button_class: 'joinple-button',
      cropping: 'server',
      multiple: 'false',
      cropping_aspect_ratio: 2.0,
      cropping_default_selection_ratio: 1,
      min_image_width: 2560,
      min_image_height: 1280
        },
    group_banner: {
      preset_name: 'group-banner',
      theme: 'default',
      button_class: 'joinple-button',
      cropping: 'server',
      multiple: 'false',
      cropping_aspect_ratio: 1.0,
      cropping_default_selection_ratio: 1,
      min_image_width: 300,
      min_image_height: 300 
      },
    group_logo: {
        preset_name: 'group-logo',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300 
      },
    landing_header: {
        preset_name: 'landing-header',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300 
      },
    landing_logo: {
        preset_name: 'landing-logo',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300 
      },
    post_image: {
        preset_name: 'post-image',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300 
      },
    social_banner: {
        preset_name: 'social-banner',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300 
      },
    social_logo: {
       preset_name: 'social-logo',
       theme: 'default',
       button_class: 'joinple-button',
       cropping: 'server',
       multiple: 'false',
       cropping_aspect_ratio: 1.0,
       cropping_default_selection_ratio: 1,
       min_image_width: 300,
       min_image_height: 300 
     },
    subject_photo: {
        preset_name: 'subject-photo',
        theme: 'default',
        button_class: 'joinple-button',
        cropping: 'server',
        multiple: 'false',
        cropping_aspect_ratio: 1.0,
        cropping_default_selection_ratio: 1,
        min_image_width: 300,
        min_image_height: 300,
        default_image: 'default_avatar.png'
      }
  }.freeze

end
