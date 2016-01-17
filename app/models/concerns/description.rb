module Description
  extend ActiveSupport::Concern

  included do 
		property :description, type: String

		validates 	:description, :presence => true
	end
end
