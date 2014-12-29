module IsOwnedBy
  extend ActiveSupport::Concern
  include SessionsHelper

  included do 
  #  before_save :check_current_user
  #  before_create :check_current_user
	  has_one	:in, :is_owned_by, rel_class: Owns
  end

end
