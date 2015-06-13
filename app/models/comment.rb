class Comment < ActiveRecord::Base
	belongs_to :User
	belongs_to :Site
	scope :newest_first, -> {order(:created_at => :desc)}
	scope :create_before, -> (time){where('created_at < ?', time)}
end
