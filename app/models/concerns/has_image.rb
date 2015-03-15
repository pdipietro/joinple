module HasImage
  extend ActiveSupport::Concern

    module ClassMethods

      def has_images(field_name)
         @field_name = Image.new(field.name, self.name) 
         has_many  :out, field_name, rel_class: HasImage
      end

      def has_image(field_name,class_name)

         set property: field_name, type: String
         mount_uploader :field_name, ImageUploader, CLASSES[class_name][field_name]
      end

    end

    module InstanceMethods

      def format class_name, field_name
        styles = Hash.new
        convert = Hash.new

        classes[class_name][field_name].each do |k|
          styles[k] = sizes[k] 
          convert[k] = k == :retina ? convert_options[k] : convert_options[:std]
        end

        " :path => ':rails_root/public/system/#{field_name}/:id/:basename_:style.:extension',
          :url => '/system/#{field_name}/:id/:basename_:style.:extension',
          :styles => #{styles},
          :convert_options => #{convert}
          validates_attachment_content_type :attachment, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
          validates_attachment_size :attachment, :less_than_or_equal_to => 4.megabytes "
      end
    end

end
