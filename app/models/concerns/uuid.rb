module Uuid
  extend ActiveSupport::Concern

  included do 
	  id_property :uuid, on: :get_or_set_uuid
	  after_initialize :set_uuid!
	end

  def set_uuid!
    @_uuid = SecureRandom.uuid
  end

  def get_or_set_uuid 
    @_uuid || SecureRandom.uuid
  end

	def uuid?
	  uuid || @_uuid
	end

end 
