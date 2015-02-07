module GroupsHelper


  BASIC_SUBSET = ["iparticipate","iadminister"]
  SECONDARY_SUBSET = ["hot","fresh","mycontacts"] 
  BASIC_ITEMS_PER_PAGE = 25
  SECONDARY_ITEMS_PER_PAGE = 5

  def secondary_subset
    ["hot","fresh","mycontacts"]
  end

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def get_subset (filter, limit = 0)
    query_string = prepare_query(filter, limit)

    @groups = Group.query_as(:groups).match("#{query_string}").pluck(:groups)
  end

  def secondary_query(filter)
    case filter
      when "iparticipate"
            "(user:User { uuid : '#{current_user.uuid}' })-[p:participates]->"
      when "iadminister"
            "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
      when "mycontacts"
            "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
      when "hot"
            "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
      when "fresh"
            "(user:User { uuid : '#{current_user.uuid}' })-[p:owns]->"
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
        else 
              "Groups"      
      end
  end

  def prepare_query(filter, limit)

      basic_query = "(groups)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) return groups order by groups.created_at desc "

      basic_query << " limit #{limit}" if (limit > 0)

      query_string = secondary_query(filter) + basic_query

      puts query_string
  end

end