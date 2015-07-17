module UploaderStore
  extend ActiveSupport::Concern

  included do
     "uploads/#{ENV['RAILS_ENV']}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end