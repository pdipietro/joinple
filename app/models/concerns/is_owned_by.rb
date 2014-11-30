module IsOwnedBy
  extend ActiveSupport::Concern

  included do 
   before_create :set_owner 
	 has_one	:in, :is_owned_by, model_class: :User, origin: :owns

   private
      def set_owner
        unless ENV['RAILS_ENV'] = "test"
          is_owned_by = session.current_user if is_owned_by.nil?
        end
      end
  end

end
