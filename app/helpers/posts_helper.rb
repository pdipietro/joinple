module PostsHelper

    def prepare_post_query(filter)

        basic_query = "(posts)-[r:belongs_to]->(group:Group { uuid : '#{current_group_uuid?}'} ) "

        puts basic_query

        query_string = secondary_query(filter) << basic_query 

        puts "++++ BEFORE RETURN: <#{query_string}> ++++"
        query_string
    end

    def secondary_query(filter)
      ""
    end

    def load_owner()

    end

end
