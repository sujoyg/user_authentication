require 'spec_helper'

describe ApplicationController do
  it { should have_before_filter(:set_current_user) }

  describe '#authorize' do
    let(:params) { {:controller => 'users', :action => 'logout'} }
    before { controller.stub!(:params).and_return(params) }

    shared_examples_for '#authorize for users#login' do
      before { controller.stub!(:params).and_return(:controller => 'users', :action => 'login') }

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
        controller.stub!(:redirect_to).with(root_path, alert: 'Please log in to access this page.').and_return(:fake)
        controller.send(:authorize).should == :fake
      end

      it 'sets the session return to address to be the current page.' do
        controller.stub!(:redirect_to)

        session[:return_to].should be_nil
        controller.send(:authorize)
        session[:return_to].should == controller.url_for(params)
      end
    end
  end

  describe '#set_current_user' do
    it 'returns true and sets current user to the one in the session.' do
      user = create(:user)
      session[:user_id] = user.id

      controller.send(:set_current_user).should be_true
      controller.instance_variable_get('@current_user').should == user
    end

    it 'returns true and sets current user to nil if there is no user in the session.' do
      session.delete :user_id
      controller.send(:set_current_user).should be_true
      controller.instance_variable_get('@current_user').should be_nil
    end
  end
end