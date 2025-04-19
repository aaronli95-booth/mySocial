class AddSeenAtToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :seen_at, :datetime
  end
end
