class AuthToken < ApplicationRecord
  before_create :generate_token

  belongs_to :user

  private

  def generate_token
    begin
      self.value = SecureRandom.hex
    end while self.class.exists?(value: value)
  end
end
