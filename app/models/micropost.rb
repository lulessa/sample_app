class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :replies, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def reply_to(usernames)
	return if (usernames.empty?)
	usernames.each do |username|
	  username.delete! "@"
	  user = User.find_by(username: username)
	  replies.create!(reply_to: user.id) unless (user.nil?)
	end
  end
end
