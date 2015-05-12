module DiscussionsHelper

  private

      def get_title(filter)
          case filter
            when "iparticipate"
                  "My discussions"
            when "iadminister"
                  "Discussion I created"
            when "mycontacts"
                  "My contact's discussions"
            when "hot"
                  "Hot discussions"
            when "fresh"
                  "Fresh discussions"
            when "search"
                  ""
            when "all"
                  "All discussions"
            when "members"
                  "Discussion participants"
            when "admins"
                  "Discussion admins"
            when "alldiscussions"
                  "All discussions"
            when "mydiscussions"
                  "My discussions"
            when "iparticipateinallgroups"
                  "My discussion in all groups"
            when "iparticipateinallsocialnetwork"
                  "My discussion in all social networks"
            else 
                 "Discussions"      
          end
      end

end
