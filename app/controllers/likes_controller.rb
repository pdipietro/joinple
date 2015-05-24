class LikesController < ApplicationController
  before_action :check_social_network
  before_action :logged_in_user

  respond_to :js

  def edit 
     puts "Params: #{params} *******************************************************************************************"
     @id = params[:id]
     @class = params[:class]
     @relationship = params[:relationship].downcase
     @dest = Neo4j::Session.query("match (dest:#{@class} { uuid : '#{@id}' }) return dest").first[0]
 
     like = Neo4j::Session.query("match (u:User { uuid : '#{current_user_id?}' })-[rel:#{@relationship}]->(dest:#{@class} { uuid : '#{@id}' }) return rel")
     if like.count == 0
        like = Neo4j::Session.query("match (user:User { uuid : '#{current_user_id?}' }), (dest:#{@class} { uuid : '#{@id}' })
               create (user)-[rel:#{@relationship}]->(dest) return rel")
     else
        like = Neo4j::Session.query("match (u:User { uuid : '#{current_user_id?}' })-[rel:#{@relationship}]->(dest:#{@class} { uuid : '#{@id}' }) delete rel")
     end
    
     partial_name = "user_#{@relationship}_#{@class.downcase}.js.erb"

     @dest
     respond_to do |format|
         format.js { render :action => partial_name, object: @dest, locals: { subject: @class} }
     end
  end

  def dummy
  #  respond_to do |format|
  #      format.js 
  #  end
  end

  def search
    results = []
    respond_to do |format|
        format.js { render :action => 'search', locals: { results: results} }
    end
  end

  def show_image
    @image = params[:img]

    #respond_to do |format|
    #    format.js 
    #end
  end

  def hide_image
    #respond_to do |format|
    #    format.js 
    #end
  end

end
