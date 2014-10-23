module Owner
  extend ActiveSupport::Concern

  included do 
	 # has_many	 :in, :owns,	type: :Person, model_class: Person
	 has_one	:out, :is_owned_by, origin: :user

	end

end
