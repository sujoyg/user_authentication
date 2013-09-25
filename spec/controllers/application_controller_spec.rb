require 'spec_helper'

describe ApplicationController do
  it { should have_before_filter(:set_current_user) }

  describe '#authorize' do
    let(:params) { {:controller => 'users', :action => 'logout'} }
    before { controller.stub(:params).and_return(params) }

    shared_examples_for '#authorize for users#login' do
      before { controller.stub(:params).and_return(:controller => 'users', :action => 'login') }

      it 'does not redirect.' do
        controller.should_not_receive(:redirect_to)
        controller.send(:authorize)
      end

      it 'returns true' do
        controller.send(:authorize).should be_true
      end
    end

    context 'when there is a current user' do
      before do
        session[:user_id] = create(:user).to_param
        controller.send(:set_current_user)
      end

      it_should_behave_like '#authorize for users#login'

      it 'does not redirect to the root page.' do
        controller.send(:authorize)
        controller.should_receive(:redirect_to).never
      end

      it 'does not set session return to address.' do
        session[:return_to].should be_nil
        controller.send(:authorize)
        session[:return_to].should be_nil
      end
    end

    context 'when there is no current user' do
      before { session.delete(:user_id) }

      it_should_behave_like '#authorize for users#login'

      it 'redirects to the root page with an alert.' do
        controller.stub(:redirect_to).with(root_path, alert: 'Please log in to access this page.').and_return(:fake)
        controller.send(:authorize).should == :fake
      end

      it 'sets the session return to address to be the current page.' do
        controller.stub(:redirect_to)

        session[:return_to].should be_nil
        controller.send(:authorize)
        session[:return_to].should == controller.url_for(params)
      end
    end
  end

  describe '#set_current_user' do
    context 'session[:user_id] is set' do
      let!(:user) { create :user }
      before { session[:user_id] = user.id }

      it 'should set current user if it is nil (and return true).' do
        controller.current_user.should be_nil
        controller.send(:set_current_user).should be_true
        controller.current_user.should == user
      end

      it 'should reset current user if it is set to some other user (and return true).' do
        other = create :user
        controller.instance_variable_set('@current_user', other)

        controller.current_user.should == other
        controller.send(:set_current_user).should be_true
        controller.current_user.should == user
      end

      it 'should keep current user if it is already set to user (and return true).' do
        controller.instance_variable_set('@current_user', user)

        controller.current_user.should == user
        controller.send(:set_current_user).should be_true
        controller.current_user.should == user
      end
    end

    context 'session[:user_id] is not set' do
      before { session[:user_id] = nil }

      it 'should keep current user if it is nil (and return true).' do
        controller.current_user.should be_nil
        controller.send(:set_current_user).should be_true
        controller.current_user.should be_nil
      end

      it 'should set current user to nil if it is set (and return true).' do
        controller.instance_variable_set('@current_user', create(:user))

        controller.current_user.should_not be_nil
        controller.send(:set_current_user).should be_true
        controller.current_user.should be_nil
      end
    end
  end
end