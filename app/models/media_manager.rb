class MediaManager 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :image,            type: String


#  include MediaManagerItem
#  include ImageSizes
	

#    ImageSizes::CLASSES.each.to_s do |class_name,v|
#
#       class_name.each.to_s do |name,v|
#         c = :"#{class_name}#{name.camelize}"
#         has_many :out, c, rel_class: HasImage
#       end
#    end

end
