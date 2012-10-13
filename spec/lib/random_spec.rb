require 'spec_helper'
require File.expand_path('../../../lib/random', __FILE__)

describe Random do
  describe '.password' do
    it 'should return a string of 32 chars.' do
      Random.password.size.should == 32
    end

    it 'should return a different password every time.' do
      Random.password.should_not == Random.password
    end
  end
end