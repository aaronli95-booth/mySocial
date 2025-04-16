class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
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
