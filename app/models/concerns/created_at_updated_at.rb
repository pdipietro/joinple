module CreatedAtUpdatedAt
  extend ActiveSupport::Concern

  included do 
		property :created_at
		property :updated_at
	end
end
