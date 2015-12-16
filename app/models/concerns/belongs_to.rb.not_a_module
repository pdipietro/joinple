module BelongsTo
  extend ActiveSupport::Concern
 # include SessionsHelper

  included do 
    has_many :out, :is_followed_by, model_class: :Subject, origin: :follows
  end

end
