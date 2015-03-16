module ImageConvertOption
  extend ActiveSupport::Concern

  included do 
          :convert_options => {
          :btn              => '-set colorspace sRGB -strip',
          :thumb            => '-set colorspace sRGB -strip',
          :icon             => '-set colorspace sRGB -strip',
          :small_logo       => '-set colorspace sRGB -strip',
          :profile          => '-set colorspace sRGB -strip',
          :original         => '-set colorspace sRGB -strip',
          :banner           => '-set colorspace sRGB -strip',
          :preview          => '-set colorspace sRGB -strip',
          :header           => '-set colorspace sRGB -strip',
          :logo             => '-set colorspace sRGB -strip',
          :retina           => '-set colorspace sRGB -strip -sharpen 0x0.5'
        }
  end
end
