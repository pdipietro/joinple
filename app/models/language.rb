class Language 
   	include Neo4j::ActiveNode
		include Uuid
		include Ctranslation

		property	  :code, constraint: :unique, type: String
		property	  :name, type: String

		validates 	:name, :presence => true
		validates 	:code, :presence => true

end

