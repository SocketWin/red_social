class User < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	# has_many :followed_users, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
	has_many :followed_users, through: :relationships, class_name: "User", source: :followed_users
	# has_many :followed_users, foreign_key: "follower_id", class_name: Relationship
	validates :name, :surname, presence: true
	validates :email, :login, presence: true, uniqueness: true
	has_secure_password
	def validate_password?
		 	 password.present? || password_confirmation.present?
	end
	validates :password, presence: true, length: { minimum: 6, if: :validate_password? }
	validates :sex, presence: true, inclusion: {in: %w(Hombre Mujer Indefinido)}
	after_initialize {
	 	 self.sex = "Indefinido" if self.sex.blank?
	 	 self.image = "imagen_defecto.png" if self.image.blank?
	}
	def following?(other_user)
	 	relationships.find_by(followed_id: other_user.id)
	end
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end
	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy!
	end
end
