module SocialNetworksHelper

#  validates   :is_visible, inclusion: { in: ["open", "private", "restricted"] }
#  validates   :status, inclusion: { in: ["run", "suspended", "locked", "banned"] }
#              :is_online false, true

	def build_filter(current_subject,filter)

    logger.debug "current_subject: #{current_subject} - current_subject.uuid: #{current_subject_id?}"

    query_string =
      case filter
        when "iparticipate"
             "(subject:Subject { uuid : '#{current_subject_id?}' })-[p:participates|owns]->(social_networks:SocialNetwork)"
        when "iadminister"
             "(subject:Subject { uuid : '#{current_subject_id?}' })-[p:owns]->(social_networks:SocialNetwork)" 
        when "ipreferes"
             "(subject:Subject { uuid : '#{current_subject_id?}' })-[p:preferes]->(social_networks:SocialNetwork)" 
        when "all"
             "(social_networks:SocialNetwork)"
      end

	end

end