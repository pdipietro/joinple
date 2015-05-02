class LikesController < ApplicationController
  before_action :check_social_network
  before_action :logged_in_user

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
    respond_to do |format|
        format.js 
    end
  end

  def search
    results = []
    respond_to do |format|
        format.js { render :action => 'search', locals: { results: results} }
    end
  end

  def BUTTALOVIA_load_social_network(sn)
     puts "============= RECEIVED SN = #{sn}"
     base = ENV['RAILS_ENV']
    # sn.downcase!
     dest = "http://dest.#{sn}.crowdupcafe.com"
         puts "Dest1: #{dest}"
     #   render 'layouts/redirect', object: dest, format: :js
        redirect_to "http://twitter.com/home"
#        redirect_to "http://dest.work.crowdupcafe.com"
    # redirect_to "http://dev.#{sn}.crowdupcafe.com"
     #switch_path("#{sn}")
   end

end
