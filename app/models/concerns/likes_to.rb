module LikesTo
  extend ActiveSupport::Concern
  include SessionsHelper

  included do 
    has_many  :in,  :likes_to, rel_class: Likes
  end

end
