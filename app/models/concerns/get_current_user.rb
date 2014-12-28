module GetCurrentUser
  extend ActiveSupport::Concern

    included do 
      def get_current_user
        current_user
      end
    end
end
