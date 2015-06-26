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


            when "allingroupsiparticipate"
                  "All discussions in my groups"
            when "allicreated"
                  "All my discussions"
            when "alliparticipate"
                  "Discussions I participate"
            else 
                 "Discussions - check title !!!"      
          end
      end

end
