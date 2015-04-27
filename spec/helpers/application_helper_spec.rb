require 'spec_helper'
require 'application_helper'

describe ApplicationHelper, :type => :helper do
  describe '#current_account' do
    it 'should return @current_account' do
      account = create :account
      helper.instance_variable_set '@current_account', account

      expect(helper.current_account).to eq account
    end
  end
end