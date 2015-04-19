module GroupsHelper
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
                  "My groups"
            when "iadminister"
                  "Groups I administer"
            when "mycontacts"
                  "My contact's groups"
            when "hot"
                  "Hot groups"
            when "fresh"
                  "Fresh groups"
            when "search"
                  ""
            when "all"
                  "All groups"
            else 
                 "Groups"      
          end
      end

      def get_icon(filter)
          case filter
            when "iparticipate"
                  "icon-torsos-all-female"
            when "iadminister"
                  "icon-tools"
            when "mycontacts"
                  "icon-heart"
            when "hot"
                  "icon-flame"
            when "fresh"
                  "icon-clock"
            when "search"
                  ""
            else 
                  "Groups"      
          end
      end

      def prepare_query(filter)

          basic_query = "(groups)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) "

          query_string = secondary_query(filter) << basic_query 

          query_string
      end

end