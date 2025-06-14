class RecreateFriendships < ActiveRecord::Migration[8.0]
  def up
    drop_table :friendships if table_exists?(:friendships)
    
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending'
      t.timestamps
    end
    
    add_index :friendships, [:user_id, :friend_id], unique: true
  end

  def down
    drop_table :friendships if table_exists?(:friendships)
  end
end