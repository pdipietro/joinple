module SocialNetworksHelper
  require 'neo4j-will_paginate_redux'

  BASIC_ITEMS_PER_PAGE = 25
  SECONDARY_ITEMS_PER_PAGE = 25

  private

      def secondary_query(filter)
        case filter
          when "iparticipate"
                "(user:User { uuid : '#{current_user.uuid}' })-[p:participates|owns]->"
          when "iadminister"
                "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
          when "mycontacts"
                "(user:User { uuid : '#{current_user.uuid}' })-[f:is_friend_of*1..2]->(afriend:User)-[p:owns]->"
          when "hot"
                "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
          when "fresh"
                ""
          when "search"
                ""
          else 
               ""      
         end
      end

      def get_title(filter)
          case filter
            when "iparticipate"
                  "My social networks"
            when "iadminister"
                  "Social networks I administer"
            when "mycontacts"
                  "My contact's social networks"
            when "search"
                  ""
            when "all"
                  "All social networks"
            else 
                 "Social networks"      
          end
      end

      def prepare_query(filter)

          basic_query = "(sn:SocialNetwork)"

          query_string = secondary_query(filter) << basic_query 

          query_string
      end

end