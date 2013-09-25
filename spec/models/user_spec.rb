require 'spec_helper'

describe User do
  describe 'attributes' do
    it { should have_attribute(:email) }
    it { should have_attribute(:password_digest) }

    it { should have_attribute(:created_at) }
    it { should have_attribute(:updated_at) }
  end

  describe 'callbacks' do
    let(:password) { random_text(:length => 32) }
    before { Random.stub(:password) { password } }

    it 'should set the password to something random if it is not set.' do
      subject.password.should be_nil
      subject.run_callbacks :validation
      subject.password.should == password
    end

    it 'should retain the password if it was already set.' do
      subject.password = password
      subject.run_callbacks :validation
      subject.password.should == password
    end
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
