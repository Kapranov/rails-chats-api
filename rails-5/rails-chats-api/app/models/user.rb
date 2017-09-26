class User < ApplicationRecord
  before_save :downcase_fields

  has_one :auth_token, dependent: :destroy

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
    length: { minimum: 5, maximum: 35 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  def self.valid_login?(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end

  private

  def downcase_fields
    self.email = email.downcase
  end
end
