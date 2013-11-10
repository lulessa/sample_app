class AddFollowerNotificationToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :follower_notification, :boolean
  end
end
