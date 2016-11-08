class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	# belongs_to :followed, class_name: "User"
	belongs_to :followed_users, class_name: "User", foreign_key: "followed_id"
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	validates_uniqueness_of :follower_id, :scope => :followed_id
	validates :follower_id, :followed_id, presence: true
	#validates :followed_id, :followed_users, presence: true
end
