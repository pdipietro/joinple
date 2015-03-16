# encoding: utf-8

begin
  require "paperclip"
rescue LoadError
  puts "Neo4jrb::Paperclip requires that you install the Paperclip gem."
  exit
end

##
# TODO
# Fix this
module Paperclip
  class << self
    # def logger
    #   Neo4j::Config[:logger]
    # end
  end
end


##
# The Neo4jrb::Paperclip extension
# Makes Paperclip play nice with the Neo4j Models
#
# Example:
#
#  class User
#    include Neo4j::ActiveNode
#    include Neo4jrb::Paperclip
#
#    has_neo4jrb_attached_file :avatar
#    validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
#  end
#
# The above example is all you need to do. This will load the Paperclip library into the User model
# and add the "has_neo4jrb_attached_file" class method. Provide this method with the same values as you would
# when using "vanilla Paperclip". The first parameter is a symbol [:field] and the second parameter is a hash of options [options = {}].
# Note that the validation must come after the call to :has_neo4jrb_attached_file.
#
# Unlike Paperclip for ActiveRecord, since MongoDB does not use "schema" or "migrations", Neo4jrb::Paperclip automatically adds the neccesary "fields"
# to your Model (MongoDB collection) when you invoke the "#has_neo4jrb_attached_file" method. When you invoke "has_neo4jrb_attached_file :avatar" it will
# automatially add the following fields:
#
#  field :avatar_file_name,    :type => String
#  field :avatar_content_type, :type => String
#  field :avatar_file_size,    :type => Fixnum
#  field :avatar_updated_at,   :type => DateTime
#
module Gsn 
  module Paperclip
    extend ActiveSupport::Concern

    module ClassMethods

      def has_attached_image(field, options = {})

        ##
        # Include Paperclip and Paperclip::Glue for compatibility
        include ::Paperclip
        include ::Paperclip::Glue


				##
  			# Define the permitted attachments for the owner class 


        ##
        # Invoke Paperclip's #has_attached_file method and passes in the
        # arguments specified by the user that invoked Neo4jrb::Paperclip#has_neo4jrb_attached_file
        has_attached_file(field, options)

        ##
        # Define the necessary collection fields in Neo4jrb for Paperclip
        property :"#{field}_file_name",    type: String
        property :"#{field}_content_type", type: String
        property :"#{field}_file_size",    type: Integer
        property :"#{field}_updated_at",   type: DateTime
      end

      ##
      # This method is deprecated
      def has_attached_file(field, options = {})
        raise "Neo4jrb::Paperclip#has_attached_file is deprecated, " +
          "Use 'has_neo4jrb_attached_file' instead"
      end
      def has_neo4jrb_attached_file(field, options = {})
        raise "Neo4jrb::Paperclip#has_neo4jrb_attached_file is deprecated, " +
          "Use 'has_attached_image' instead"
      end

    end
  end
end
