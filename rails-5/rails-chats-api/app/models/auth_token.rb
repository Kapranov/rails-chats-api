class AuthToken < ApplicationRecord
  before_validation :generate_token

  belongs_to :user

  #validates_associated :user

  validates :user_id,
    presence: true, uniqueness: true

  private

  def generate_token
    begin
      self.value = SecureRandom.uuid.gsub(/\-/,'')
    end while self.class.exists?(value: value)
  end
end
