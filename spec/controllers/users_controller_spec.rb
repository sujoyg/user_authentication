require 'spec_helper'

describe UsersController do
  describe '#login' do
    let(:email) { random_email }
    let(:password) { random_text }

    shared_examples_for 'login failure' do
      it 'redirects to root page.' do
        post :login, email: email, password: password
        response.should redirect_to root_path
      end

      it 'sets an error message.' do
        post :login, email: email, password: password
        flash.alert.should == 'Please check email and password.'
      end
    end

    context 'when user does not exist' do
      before { User.should_not exist email: email }

      it_behaves_like 'login failure'
    end

    context 'when password is incorrect' do
      before { create(:user, email: email, password: random_text) }

      it_behaves_like 'login failure'
    end

    describe 'when password is correct' do
      before { @user = create(:user, email: email, password: password) }

      it 'sets the user in the session.' do
        User.should exist email: email

        session[:user_id].should be_nil
        post :login, email: email, password: password
        session[:user_id].should == @user.id
      end

      context 'when session has a return to address' do
        let(:url) { random_url }
        before { session[:return_to] = url }

        it 'redirects to the specified address.' do
          post :login, email: email, password: password
          response.should redirect_to url
        end

        it 'deletes the return to address.' do
          session[:return_to].should == url
          post :login, email: email, password: password
          session[:return_to].should be_nil
        end
      end

      context 'when session does not have a return to address' do
        it 'redirects to the root page.' do
          post :login, email: email, password: password
          response.should redirect_to root_path
        end
      end
    end
  end

  describe '#logout' do
    it 'redirects to the root page.' do
      get :logout
      response.should redirect_to root_path
    end

    it 'removes the user in the session if it is set.' do
      session[:user_id] = create(:user).id

      session[:user_id].should be_present
      get :logout
      session[:user_id].should be_nil
    end

    it 'keeps the session unchanged if there was no user.' do
      session[:user_id].should be_nil
      get :logout
      session[:user_id].should be_nil
    end

    it 'removes the return_to in the session if it is set.' do
      session[:return_to] = random_url

      session[:return_to].should be_present
      get :logout
      session[:return_to].should be_nil
    end

    it 'keeps the session unchanged if there was no return_to.' do
      session[:return_to].should be_nil
      get :logout
      session[:return_to].should be_nil
    end
  end
end

