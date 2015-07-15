module MediaManagersHelper
  require 'neo4j-will_paginate_redux'

  BASIC_ITEMS_PER_PAGE = 20
  SECONDARY_ITEMS_PER_PAGE = 20

 # private

       def prepare_query(filter)

          puts "++++ entered groups_helper/prepare_query(filter) ++++"

          basic_query = "(images)-[r:owned-by]->(u:Subject { uuid : '#{current_subject.uuid}'} ) "

          puts "++++ IMAGES BASIC QUERY BEFORE RETURN: <#{basic_query}> ++++"
          basic_query
      end


end
