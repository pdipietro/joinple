module GroupsHelper
  require 'neo4j-will_paginate_redux'

  BASIC_ITEMS_PER_PAGE = 7
  SECONDARY_ITEMS_PER_PAGE = 5

  def secondary_subset
    ["hot","fresh","mycontacts"]
  end

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end

  # GET /groups/list/:filter(/:limit(/:subject))
  def get_subset (actual_page, items_per_page, filter)
    query_string = prepare_query(filter)

    puts "query string:: #{query_string}"
    #.paginate(:page => 2, :per_page => 20, return: :p, order: :name) 
    grp = Group.as(:groups).query.match(query_string).proxy_as(Group, :groups).paginate(:page => actual_page, :per_page => items_per_page, return: :groups, order: "groups.created_at desc")
    puts "get_subset count: #{grp.count} - class: #{grp.class.name} - #{grp}"
    grp
  end

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


  def get_filter(filter)
      case filter
        when "iparticipate"
              ""
        when "iadminister"
              ""
        when "mycontacts"
              "where "
        when "hot"
              "Hot groups"
        when "fresh"
              "Fresh groups"
        when "search"
             ""
        else 
              "Groups"      
      end
  end

  def new_prepare_query(filter, limit)

      Core::Query.Group.as(:groups)
        .query.proxy(Group, :groups).is_owned_by(:user).pluck(:group,'collect(user)')

      basic_query = "(groups:Group)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) return groups order by groups.created_at desc "
      puts basic_query

      #filter_query = get_filter(filter)


      #basic_query << " limit #{limit}" if (limit > 0)
      #puts basic_query



      #query_string = secondary_query(filter) + basic_query 

      puts query_string
      query_string
  end

  def prepare_query(filter)

      basic_query = "(groups)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) return groups order by groups.created_at desc "
      basic_query = "(groups)-[r:belongs_to]->(sn:SocialNetwork { uuid : '#{current_social_network.uuid}'} ) "

      puts basic_query

#      filter_query = get_filter(filter)


#      basic_query << " limit #{limit}" if (limit > 0)
#      puts basic_query

      query_string = secondary_query(filter) << basic_query 

      puts "++++ BEFORE RETURN: <#{query_string}> ++++"
      query_string
  end
end