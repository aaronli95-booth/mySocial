class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  
  # Profile validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :school, presence: true
  validates :bio, length: { maximum: 500 }, allow_blank: true

  validate :acceptable_avatar

  private

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/png image/jpg])
      errors.add(:avatar, "must be a JPEG, PNG, or JPG")
    end

    unless avatar.byte_size <= 5.megabytes
      errors.add(:avatar, "must be less than 5MB")
    end
  end
end
