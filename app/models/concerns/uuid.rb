module Uuid
  extend ActiveSupport::Concern

  included do 
		id_property :uuid, on: :create_uuid
	end

	def create_uuid
		SecureRandom::uuid
	end

end
