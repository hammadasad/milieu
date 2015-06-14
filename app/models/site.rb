class Site < ActiveRecord::Base
	has_many :comments

	validates :address, :description, :contact_info, :status, presence: true

	# GeoCoder
	  geocoded_by :address
	  after_validation :geocode, if: :address_changed?
end
