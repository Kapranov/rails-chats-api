require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { should validate_presence_of :message }
  it { should validate_length_of(:message).is_at_least(4) }
  it { should validate_length_of(:message).is_at_most(25) }
end
