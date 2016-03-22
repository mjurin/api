require 'rails_helper'

describe User do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  let(:user) { build(:user) }

  describe "ActiveModel validations" do
    # Basic validations
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email) }

    # Format validations
    it { expect(user).to allow_value("dhh@nonopinionated.com").for(:email) }
    it { expect(user).to_not allow_value("base@example").for(:email) }
    it { expect(user).to_not allow_value("blah").for(:email) }
    # Inclusion/acceptance of values
    it { expect(user).to validate_length_of(:password).is_at_least(6) }
    it { expect(user).to validate_confirmation_of(:password) }  # Ensure two values match
  end

  describe "ActiveRecord associations" do
    it { expect(user).to have_many(:oauths).dependent(:destroy) }
  end

  describe 'to_json' do
    let(:user) { create(:user) }

    it 'expects not to have password_digest' do
      expect(JSON.parse(user.to_json)).to_not have_key(:password_digest)
    end
  end
end
