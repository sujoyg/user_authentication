require File.expand_path('../../../lib/random', __FILE__)

class User < ActiveRecord::Base
  has_secure_password

  before_validation { |user| user.password = Random.password if user.password.nil? }
  validates_presence_of :email
end
