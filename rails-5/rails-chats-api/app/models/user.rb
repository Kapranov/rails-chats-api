class User < ApplicationRecord
  before_save :downcase_fields
  after_create :init_token

  has_one :auth_token, dependent: :destroy

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_associated :auth_token
  validates :email, presence: true,
    length: { minimum: 5, maximum: 35 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  private

  def downcase_fields
    self.email = email.downcase
  end

  def init_token
    self.create_auth_token!
  end
end
