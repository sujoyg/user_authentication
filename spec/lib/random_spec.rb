require 'spec_helper'
require File.expand_path('../../../lib/random', __FILE__)

describe Random do
  describe '.password' do
    it 'should return a string of 32 chars.' do
      expect(Random.password.size).to eq 32
    end

    it 'should return a different password every time.' do
      expect(Random.password).to_not eq Random.password
    end
  end
end
