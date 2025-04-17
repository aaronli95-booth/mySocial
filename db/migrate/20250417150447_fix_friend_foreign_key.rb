class FixFriendForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Remove the broken FK that points to 'friends'
    remove_foreign_key :friendships, column: :friend_id

    # Add the correct FK pointing to 'users' table
    add_foreign_key :friendships, :users, column: :friend_id
  end
end
