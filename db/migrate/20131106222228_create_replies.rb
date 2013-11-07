class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :micropost_id
      t.integer :reply_to

      t.timestamps
    end
    add_index :replies, :micropost_id
  end
end
