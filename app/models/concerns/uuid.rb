module Uuid
  extend ActiveSupport::Concern

  included do 
	  id_property :uuid, on: :get_or_set_uuid
	  after_initialize :set_uuid!
    attr_accessor :_uuid
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

  def _uuid= (an_uuid)
    @_uuid = an_uuid
  end

  def initialize (args = {})
    @_uuid = SecureRandom.uuid
    if args.class == Hash 
      unless args[:uuid].nil?
        @_uuid = args[:uuid]
      end
    end
  end

end 
