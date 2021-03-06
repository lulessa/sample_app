class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", 
									 class_name: "Relationship",
									 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	before_save { email.downcase! }
	before_create :create_remember_token, :create_confirm_token
	validates :name, presence: true, length: { maximum: 50 }
	validates :username, presence: true, 
						 length: { maximum: 30 },
						 format: { with: /\A[0-9A-Za-z_]+\z/ },
						 uniqueness: { case_sensitive: false }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, unless: Proc.new { |user| user.password.blank? }
	state_machine initial: :inactive do
		state :inactive, value: 0
		state :active, value: 1
		
		event :activate do
		  transition :inactive => :active
		end

		event :deactivate do
		  transition :active => :inactive
		end
	end
	
	def feed
	  Micropost.from_users_followed_by(self)
	end
	
	def following?(other_user)
	  relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
	  relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
	  relationships.find_by(followed_id: other_user.id).destroy!
	end
	
	def send_password_reset
	  generate_token(:password_reset_token)
	  self.password_reset_sent_at = Time.zone.now
	  save!
	  Notifier.password_reset(self).deliver
	end
	
	def send_email_confirmation
	  Notifier.confirm_email(self).deliver
	end

	def User.new_remember_token
	  SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
	  Digest::SHA1.hexdigest(token.to_s)
	end
	
	def generate_token(column)
	  begin
		self[column] = SecureRandom.urlsafe_base64
	  end while User.exists?(column => self[column])
	end
	
	private
	
	  def create_remember_token
	  	self.remember_token = User.encrypt(User.new_remember_token)
	  end
	  
	  def create_confirm_token
	  	generate_token(:confirm_token)
	  end
end
