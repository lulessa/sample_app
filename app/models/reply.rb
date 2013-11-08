class Reply < ActiveRecord::Base
  belongs_to :micropost
  default_scope -> { order('created_at DESC') }
  validates :micropost_id, presence: true
  validates :reply_to, presence: true
end
