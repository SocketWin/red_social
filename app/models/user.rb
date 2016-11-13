class User < ActiveRecord::Base
	AVATAR = File.join Rails.root, 'app', 'assets', 'images', 'avatar_store'
	before_create :create_remember_token
	after_save :save_photo
	has_many :posts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	# has_many :followed_users, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
	has_many :followed_users, through: :relationships, class_name: "User", source: :followed_users
	# has_many :followed_users, foreign_key: "follower_id", class_name: Relationship
	has_many :followers, through: :relationships, class_name: "User", source: :followers
	validates :name, :surname, presence: true
	validates :email, :login, presence: true, uniqueness: true
	has_secure_password
	def validate_password?
		password.present? || password_confirmation.present?
	end
	validates :password, presence: true, length: { minimum: 6, if: :validate_password? }, on: :create
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

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def image_file=(file_data)
		unless file_data.blank?
			@file = file_data
			@extension = file_data.original_filename.split('.').last.downcase
			self.image = "avatar_store/#{login}.#{@extension}"
		end
	end

	def image_filename
		File.join AVATAR, "#{login}.#{@extension}"
	end

	def feed
		Post.from_users_followed_by(self)
	end

	private
	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end

	def save_photo
		if @file
			FileUtils.mkdir_p AVATAR
			File.open(image_filename, 'wb') do |f|
				f.write(@file.read)
			end
			@file_data = nil
		end
	end

end
