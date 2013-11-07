class Reply < ActiveRecord::Base
  belongs_to :micropost
  validates :micropost_id, presence: true
  validates :reply_to, presence: true
end
