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

    it 'expects to have name' do
      expect(JSON.parse(user.to_json)).to have_key('name')
    end

  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(user).to respond_to(:name) }
    end

    context "#method name" do
      it "expect to return firstname + lastname" do
        expect(user.name).to eq("#{user.firstname} #{user.lastname}")
      end
    end
  end

  describe "public class methods" do
    # context "responds to its methods" do
    #   it { expect(factory_instance).to respond_to(:public_method_name) }
    #   it { expect(factory_instance).to respond_to(:public_method_name) }
    # end

    # context "executes methods correctly" do
    #   context "self.method name" do
    #     it "does what it's supposed to..."
    #       expect(factory_instance.method_to_test).to eq(value_you_expect)
    #     end
    #   end
    # end
  end

end
