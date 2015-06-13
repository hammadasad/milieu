class User < ActiveRecord::Base
	# attr_accessor :password, :password_confirmation
	# def authenticate
	has_secure_password

	has_many :Comments

end
