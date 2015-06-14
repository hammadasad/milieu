class User < ActiveRecord::Base
	has_secure_password
  	validates_presence_of :fname, :lname, :email, :user_name, :password_digest
  	has_many :comments
end
