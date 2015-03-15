module Group::ImageSizes
  extend ActiveSupport::Concern

  included do 
    has_many  :out, :covers,    model_class: :HasImage
    has_one   :out, :logo,      model_class: :HasImage
  end

end