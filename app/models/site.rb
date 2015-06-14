class Site < ActiveRecord::Base
	has_many :comments

	validates :address, :description, :contact_info, :status, presence: true


end
