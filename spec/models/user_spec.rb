require 'spec_helper'

describe User do
  describe 'attributes' do
    it { should have_attribute(:email) }
    it { should have_attribute(:password_digest) }

    it { should have_attribute(:created_at) }
    it { should have_attribute(:updated_at) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
  end
end
