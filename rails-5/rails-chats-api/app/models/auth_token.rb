class AuthToken < ApplicationRecord
  before_validation :generate_token

  belongs_to :user, foreign_key: :user_id, class_name: :User, optional: true

  validates_associated :user

  validates :value, presence: true,
    uniqueness: { scope: :user_id },
    length: { minimum: 25, allow_blank: false }

  private

  def generate_token
    begin
      self.value = SecureRandom.uuid.gsub(/\-/,'')
    end while self.class.exists?(value: value)
  end
end
