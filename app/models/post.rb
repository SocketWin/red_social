class Post < ActiveRecord::Base
	belongs_to :user
	validates :comment, presence: true, length: { minimum: 4, maximum: 140 }
	validates :user_id, presence: true
	default_scope { order('created_at DESC') }
	def self.from_users_followed_by(user)
		followed_user_ids = user.followed_user_ids
		where("user_id IN (:followed_user_ids) OR user_id = :user_id", followed_user_ids:
				followed_user_ids, user_id: user)
	end
end
