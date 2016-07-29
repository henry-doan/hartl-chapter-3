class User < ApplicationRecord
	has_secure_password

	before_save :downcase_email
	attr_accessor :create_remember_token, :activation_token, :reset_token
	before_create :create_activation_digest
	
	before_create :create_remember_token

	validates_presence_of :name, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates_presence_of :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

	validates_presence_of :password, length: { minimum: 6 }, allow_nil: true
	validates_presence_of :password_confirmation

	class << self
  # Returns the hash digest of the given string.
	  def digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	  end

	  # Returns a new token
	  def new_token
	  	SecureRandom.urlsafe_base64
	  end
	end
  
  # remembers a user in the database for use in persistent sessions.
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  # return true if the given token matches the digest
  def authenticated?(attribute, token)
  	digest = send("#{attribute}_digest")
  	return false if digest.nil?
  	BCrypt::Password.new(password_digest).is_password?(token)
  end

  # Forgets a user. 
  def forget
  	update_attribute(:remember_digest, nil)
  end
  # Activates an account
  def activate
  	update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
  	UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes 
  # could be wrong here
  def create_reset_digest
  	self.reset_token = User.new_token
  	update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
  	UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
  	reset_sent_at < 2.hours.ago
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
