class StaticPagesController < ApplicationController
  respond_to :js

  def home
   respond_to do |format|
     format.js
     format.html 
   end
  end

  def help
   respond_to do |format|
     format.js 
   end
  end

  def about
   respond_to do |format|
     format.js 
   end
  end

  def contact
   respond_to do |format|
     format.js 
   end
  end
end
