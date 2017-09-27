require 'rails_helper'

RSpec.describe User, type: :model do
  let(:auth_token) { AuthToken.new }
  let(:valid_attributes) {
    {
      email: "TEST@EXAMPLE.COM",
      password: "password",
      password_confirmation: "password"
    }
  }

  before do
    user = User.new
    allow( user ).to receive(:save!)
    allow( User ).to receive(:new) { user }
  end

  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should have_one(:auth_token).dependent(:destroy) }
  it { should validate_length_of(:email).is_at_least(5) }
  it { should validate_length_of(:email).is_at_most(35) }

  it { is_expected.to callback(:downcase_fields).before(:save) }
  it { is_expected.to callback(:init_token).after(:create) }

  it "downcases an email before saving" do
    user = User.new(valid_attributes)
    user.email = "test@example.com"
    #expect(user.save).to eq true
    expect(user.email).to eq("test@example.com")
  end
end
