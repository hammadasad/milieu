class Site < ActiveRecord::Base
	has_many :comments

	validates :address, :lattitude, :longitude, :description, :contact_info, :status, presence: true

	
end
