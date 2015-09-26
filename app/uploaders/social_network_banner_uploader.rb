# encoding: utf-8

class SocialNetworkBannerUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include Cloudinary::CarrierWave
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
