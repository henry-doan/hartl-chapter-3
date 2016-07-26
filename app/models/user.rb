class User < ApplicationRecord
	has_secure_password

	before_save { |user| user.email = email.downcase }

	validates_presence_of :name, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_presence_of :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

	validates_presence_of :password, length: { minimum: 6 }
	validates_presence_of :password_confirmation
end
