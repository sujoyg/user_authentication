FactoryGirl.define do
  factory :user do |user|
    user.email { random_email }
    user.password { random_text }
  end
end