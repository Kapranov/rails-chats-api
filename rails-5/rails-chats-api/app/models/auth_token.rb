class AuthToken < ApplicationRecord
  belongs_to :user

  before_create :assign_value

  private

  def assign_value
    self.value = SecureRandom.uuid
  end
end
