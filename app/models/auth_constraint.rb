class AuthConstraint
  def matches?(request) 
#      puts ("!!request.session[:admin]: #{!!request.session[:admin]}")
#      !!request.session[:admin]
#      puts ("is_admin?: #{SessionController::is_admin?}")
#      !!SessionController::is_admin?
				true
  end
end
