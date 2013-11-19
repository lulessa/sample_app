class AddStateConfirmTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, default: 0
    add_column :users, :confirm_token, :string
  end
end
