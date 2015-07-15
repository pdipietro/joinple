module MediaManagerItem
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy

  has_many :out, discussion_header, rel_class: HasImage
  has_many :out, group_cover, rel_class: HasImage
  has_many :out, group_header, rel_class: HasImage
  has_many :out, group_logo, rel_class: HasImage
  has_many :out, post_header, rel_class: HasImage
  has_many :out, landing_page_header, rel_class: HasImage
  has_many :out, landing_page_logo, rel_class: HasImage
  has_many :out, social_network_logo, rel_class: HasImage
  has_many :out, subject_avatar, rel_class: HasImage
  has_many :out, subject_image, rel_class: HasImage

end
