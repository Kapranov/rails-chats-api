class Chat < ApplicationRecord
  before_save :downcase_fields

  validates :message, presence: true,
    length: { minimum: 4,  maximum: 25, allow_blank: false }

  private

  def downcase_fields
    self.message = message.downcase
  end
end
