module FormsHelper
  def create_form(jpl_parms, parms)
    #splat(jpl_parms, jpl_parms.class.name)
    #splat(parms, parms.class.name)
    instances = {}
    instances[:parms] = parms
    instances[:f_uuid] = "#{parms[:action]}-#{parms[:id]}"
    jpl_parms.each do |key, value|
      instances[key] = value
    end
    instances
  end
end
