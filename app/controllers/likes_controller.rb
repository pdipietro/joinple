class LikesController < ApplicationController
  before_action :check_social_network
  before_action :logged_in_user

  def edit 
     puts "Params: #{params} *******************************************************************************************"
     @id = params[:id]
     @class = params[:class]
     @rel_type = params[:rel_type].downcase
     puts "******** 0) ID: #{@id} - class: #{@class}"
     @dest = Neo4j::Session.query("match (dest:#{@class} { uuid : '#{@id}' }) return dest").first[0]
     puts "******** 1) ID: #{@id}, dest: #{@dest}, dest.class: #{@dest.class}"
 
     like = Neo4j::Session.query("match (u:User { uuid : '#{current_user.uuid}' })-[rel:#{@rel_type}]->(dest:#{@class} { uuid : '#{@id}' }) return rel")
     puts "like: #{like}"
    if like.count == 0
       base = Object.const_get("#{@rel_type.capitalize}::#{@rel_type.capitalize}")
       rel = base.create(from_node: current_user, to_node: @dest)
    else
       like = Neo4j::Session.query("match (u:User { uuid : '#{current_user.uuid}' })-[rel:#{@rel_type}]->(dest:#{@class} { uuid : '#{@id}' }) delete rel")
    end
    
    @a = ["##{@dest.uuid}",@dest]
    @a
    @dest
    respond_to do |format|
        format.js
    end
  end
end
