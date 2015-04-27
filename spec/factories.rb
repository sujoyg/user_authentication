FactoryGirl.define do
  factory :account do |account|
    account.email { random_email }
    account.password { random_text }
  end
end