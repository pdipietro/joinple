module IsOwnedBy
  extend ActiveSupport::Concern

  included do 
	 has_one	:in, :owns, model_class: :User, origin: :owns
  end

end
