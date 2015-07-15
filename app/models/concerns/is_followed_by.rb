module IsFollowedBy
  extend ActiveSupport::Concern
 # include SessionsHelper

  included do 
	  has_many :in, :is_followed_by, model_class: :Subject, origin: :follows
  end

end
