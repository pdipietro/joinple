module IsLikedBy
  extend ActiveSupport::Concern

  included do 
	  has_many :in, :likes, model_class: :User, origin: :likes
  end

end
