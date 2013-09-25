require File.expand_path('../../../lib/random', __FILE__)

class User < ActiveRecord::Base
  has_secure_password

  before_validation { |user| user.password = Random.password if user.password.nil? }
  validates :email, presence: true, uniqueness: true, email: true
end

app_model = File.join Rails.root, 'app/models/user.rb'
require app_model if File.exists? app_model
