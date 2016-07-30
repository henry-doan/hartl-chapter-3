class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  	# Confirms a signed-in user
  	def signed_in_user
      unless signed_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to signin_path
      end
    end
end
