class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true # , format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: 'must be 15 characters long and can only have chars, numbers and underscores' }
  validates :email, presence: true, uniqueness: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'is not in proper format' }
  validates :name, presence: true, length: { in: 3..20, message: 'must be min 3 character and max 20 characters' }

  validate :password_validation

  has_many :sessions, dependent: :destroy

  has_many :tweets, dependent: :destroy

  private

  def password_validation
    if password.nil? && password_digest.nil?
      errors.add(:password, 'must be present')
    end
  end
end