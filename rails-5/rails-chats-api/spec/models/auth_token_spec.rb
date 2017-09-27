require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  it { should callback(:generate_token).before(:validation) }
  it { should belong_to(:user) }
  it { should have_db_index(:user_id) }
  it { should validate_uniqueness_of(:user_id) }
  it { should validate_presence_of(:user_id) }

  describe '#generate_token' do
    before { expect(SecureRandom).to receive(:uuid).and_return('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') }
    before { expect(subject).to receive(:value=).with('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') }

    # it { expect { subject.send :generate_token }.to_not raise_error }
  end
end
