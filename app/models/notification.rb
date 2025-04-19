class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  TYPES = %w[
    friend_request
    friend_request_accepted
    friend_request_rejected
    new_post
  ].freeze

  validates :action_type, inclusion: { in: TYPES }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def unread?
    read_at.nil?
  end
end
