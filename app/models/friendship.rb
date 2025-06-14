class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id }
  validates :status, inclusion: { in: %w[pending accepted] }

  validate :not_self_friendship

  private

  def not_self_friendship
    if user_id == friend_id
      errors.add(:friend, "can't be the same as the user")
    end
  end
end
