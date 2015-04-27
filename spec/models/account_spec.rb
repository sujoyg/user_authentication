require 'spec_helper'

describe Account, :type => :model do
  describe 'attributes' do
    it { should have_attribute(:email) }
    it { should have_attribute(:password_digest) }

    it { should have_attribute(:created_at) }
    it { should have_attribute(:updated_at) }
  end

  describe 'callbacks' do
    let(:password) { random_text(:length => 32) }
    before { allow(Random).to receive(:password).and_return(password) }

    it 'should set the password to something random if it is not set.' do
      expect(subject.password).to be_nil
      subject.run_callbacks :validation
      expect(subject.password).to eq password
    end

    it 'should retain the password if it was already set.' do
      subject.password = password
      subject.run_callbacks :validation
      expect(subject.password).to eq password
    end
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
