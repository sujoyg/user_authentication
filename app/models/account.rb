require File.expand_path('../../../lib/random', __FILE__)

class Account < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
end

app_model = File.join Rails.root, 'app/models/account.rb'
require app_model if File.exists? app_model
