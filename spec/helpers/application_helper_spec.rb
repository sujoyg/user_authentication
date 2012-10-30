require 'spec_helper'
require 'application_helper'

describe ApplicationHelper do
  describe '#current_user' do
    it 'should return @current_user' do
      user = create :user
      helper.instance_variable_set '@current_user', user

      helper.current_user.should == user
    end
  end
end