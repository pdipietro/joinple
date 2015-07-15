module GetCurrentSubject
  extend ActiveSupport::Concern

    included do 
      def get_current_subject
        current_subject
      end
    end
end
