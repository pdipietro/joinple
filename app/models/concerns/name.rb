module Name
  extend ActiveSupport::Concern

  included do 
		property 		:name, type: String

		validates 	:name, :presence => true
	end
end
