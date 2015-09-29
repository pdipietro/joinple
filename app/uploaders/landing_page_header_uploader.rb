# encoding: utf-8

class LandingPageHeaderUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
