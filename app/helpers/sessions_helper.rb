module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		session[:user_id] = user.id		
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		session.delete(:user_id)
    @current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
		#work on cookies
	end
end
