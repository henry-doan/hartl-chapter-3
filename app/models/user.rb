class User < ApplicationRecord
	has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token

	validates_presence_of :name, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_presence_of :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

	validates_presence_of :password, length: { minimum: 6 }, allow_nil: true
	validates_presence_of :password_confirmation


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
