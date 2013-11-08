class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :replies, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
	reply_micropost_ids = "SELECT micropost_id FROM replies
						   WHERE reply_to = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id 
		   OR id IN (#{reply_micropost_ids})", user_id: user.id)
  end

  def reply_to(usernames)
	return false if (usernames.empty?)
	usernames.map! {|x| x.to_s.delete "@" }
	user_ids = User.select(:id).where(username: usernames)
	user_ids.each {|u| replies.create!(reply_to: u.id) }
	user_ids.count
  end
end
