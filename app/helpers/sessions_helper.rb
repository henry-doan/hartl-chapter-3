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

	def current_user?(user)
		user == current_user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
		#work on cookies
	end

	# redirect to stored location or to the default
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# stores the url trying to be accessed
	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end
