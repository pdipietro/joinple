class LikesController < ApplicationController
  before_action :check_social_network
  before_action :logged_in_subject

  respond_to :js

  def edit 
     #puts "Params: #{params} *******************************************************************************************"
     @id = params[:id]
     @class = params[:class]
     @relationship = params[:relationship].downcase
     @dest = Neo4j::Session.query("match (dest:#{@class} { uuid : '#{@id}' }) return dest").first[0]
 
     like = Neo4j::Session.query("match (u:Subject { uuid : '#{current_subject_id?}' })-[rel:#{@relationship}]->(dest:#{@class} { uuid : '#{@id}' }) return rel")
     if like.count == 0
        like = Neo4j::Session.query("match (subject:Subject { uuid : '#{current_subject_id?}' }), (dest:#{@class} { uuid : '#{@id}' })
               create (subject)-[rel:#{@relationship}]->(dest) return rel")
     else
        like = Neo4j::Session.query("match (u:Subject { uuid : '#{current_subject_id?}' })-[rel:#{@relationship}]->(dest:#{@class} { uuid : '#{@id}' }) delete rel")
     end
    
     partial_name = "subject_#{@relationship}_#{@class.downcase}.js.erb"

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
  end

  def show_content
    @subject = params[:subject]
    @rel = params[:rel]
    @class = param[:class].downcase
    @class_uuid = params[:object]

    subject_list = Neo4j::Session.query("match (u:Subject { uuid : '#{@subject}' })-[rel:#{@rel}]->(obj:#{@class} { uuid : '#{@class_uuid}' }) return unique subject order by first_name, last_name")

    respond_to do |format|
         format.js { render partial: show_content, object: subject_list }
    end

  end

  def hide
  end

end
