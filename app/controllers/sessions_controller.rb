class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.activated?
				sign_in user
				params[:session][:remember_me] == '1' ? remember(user) : forget(user)
				redirect_back_or user
			else
				message = "Account not activated."
				message += "Check your email for the activation link."
				flash[:warning] = message
				redirect_to root_path
			end
		else
			flash[:error] = 'Invalid email/password'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

	private

		def session_params
			params.require(:session).permit(:email, :password)
		end
end
