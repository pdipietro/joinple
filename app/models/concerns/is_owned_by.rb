module IsOwnedBy
  extend ActiveSupport::Concern
  include SessionsHelper

  included do 
  #  before_save :check_current_subject
  #  before_create :check_current_subject
	  has_one	:in, :is_owned_by, rel_class: Owns
  end

end
