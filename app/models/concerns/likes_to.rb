module LikesTo
  extend ActiveSupport::Concern
  include SessionsHelper

  included do 
    has_many  :in,  :likes_to, model_class: User, origin: :likes
  end

end
