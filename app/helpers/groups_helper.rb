module GroupsHelper
  require 'neo4j-will_paginate_redux'

  BASIC_ITEMS_PER_PAGE = 25
  SECONDARY_ITEMS_PER_PAGE = 25

  private

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
            when "members"
                  "Group members"
            when "admins"
                  "Group admins"
            else 
                 "Groups"      
          end
      end

end