class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  
  # Friendship associations
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships, source: :friend
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, -> { where(friendships: { status: 'accepted' }) }, through: :inverse_friendships, source: :user
  
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  
  # Profile validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :school, presence: true
  validates :bio, length: { maximum: 500 }, allow_blank: true

  validate :validate_avatar

  # Friendship methods
  def friends_with?(user)
    friendships.exists?(friend: user, status: 'accepted') || 
    inverse_friendships.exists?(user: user, status: 'accepted')
  end

  def pending_friendship_with?(user)
    friendships.exists?(friend: user, status: 'pending') || 
    inverse_friendships.exists?(user: user, status: 'pending')
  end

  def sent_friend_request_to?(user)
    friendships.exists?(friend: user, status: 'pending')
  end

  def received_friend_request_from?(user)
    inverse_friendships.exists?(user: user, status: 'pending')
  end

  # Notification associations
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :created_notifications, class_name: 'Notification', foreign_key: :actor_id, dependent: :destroy

  private

  def validate_avatar
    return unless avatar.attached?

    unless avatar.blob.content_type.in?(%w[image/png image/jpeg image/jpg])
      errors.add(:avatar, "must be a PNG, JPG, or JPEG")
    end

    unless avatar.blob.byte_size <= 5.megabytes
      errors.add(:avatar, "must be less than 5MB")
    end
  end
end
