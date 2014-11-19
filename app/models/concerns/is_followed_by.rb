module IsFollowedBy
  extend ActiveSupport::Concern

  included do 
	  has_many :in, :follows, model_class: :User, origin: :follows
  end

end
