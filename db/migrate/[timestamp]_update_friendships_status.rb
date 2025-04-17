class UpdateFriendshipsStatus < ActiveRecord::Migration[7.1]
  def change
    remove_column :friendships, :confirmed
    add_column :friendships, :status, :string, default: 'pending'
  end
end 