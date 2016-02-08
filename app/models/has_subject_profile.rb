class HasSubjectProfile
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Subject
  to_class    :SubjectProfile
  type 'has_profile'
end
