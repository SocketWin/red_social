class Post < ActiveRecord::Base
	belongs_to :user
	validates :comment, presence: true, length: { minimum: 4, maximum: 140 }
	validates :user_id, presence: true
	default_scope { order('created_at DESC') }
end
