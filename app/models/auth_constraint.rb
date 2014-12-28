class AuthConstraint
  def matches?(request) 
      puts ("!!request.session[:admin] = #{!!request.session[:admin]}")
      !!request.session[:admin]
  end
end
