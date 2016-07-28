class User < ApplicationRecord
	has_secure_password

	before_save :downcase_email
	before_save :create_remember_token, :activation_token
	before_create :create_activation_digest

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

  # Returns a new token
  def User.new_token
  	SecureRandom.urlsafe_base64
  end
  
  # return true if the given token matches the digest
  def authenticated?(attribute, token)
  	digest = send("#{attribute}_digest")
  	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
  	update_columns(activated: FILL_IN, activated_at: FILL_IN)
  end

  # Sends activation email
  def send_activation_email
  	UserMailer.account_activation(self).deliver_now
  end
	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

		def downcase_email
			self.email = email.downcase
		end

		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
