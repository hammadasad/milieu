class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :site
	
	scope :newest_first, -> {order(:created_at => :desc)}
	scope :create_before, -> (time){where('created_at < ?', time)}
end
