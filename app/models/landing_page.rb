class LandingPage 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
 
  property    :description,  :type =>  String
  validates   :description, length: { minimum: 150 }, allow_blank: true

  property  :logo,              type: String
  mount_uploader :logo,         LandingPageLogoUploader 
  property  :header,            type: String
  mount_uploader :header,       LandingPageHeaderUploader 


end
