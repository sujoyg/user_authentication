require 'spec_helper'

describe UsersController do
  let(:referer) { random_url }
  before { request.env['HTTP_REFERER'] = referer }

  describe '#login' do
    let(:email) { random_email }
    let(:password) { random_text }

    context 'failure' do
      shared_examples_for 'login failure' do
        it 'redirects to referring page.' do
          post :login, email: email, password: password
          response.should redirect_to referer
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

      context 'when authentication failed' do
        before { create(:user, email: email, password: random_text) }

        it_behaves_like 'login failure'
      end
    end

    context 'success' do
      let!(:user) { create(:user, email: email, password: password) }

      it 'should set the user in the session.' do
        session[:user_id].should be_nil
        post :login, email: email, password: password
        session[:user_id].should == user.id
      end

      it 'should set the current_user.' do
        controller.current_user.should be_nil
        post :login, email: email, password: password
        controller.current_user.should == user
      end

      context 'controller has an on_login callback' do
        before do
          class UsersController
            def on_login
              head :ok
            end
          end
        end

        after do
          class UsersController
            remove_method :on_login
          end
        end

        it 'should invoke the callback.' do
          controller.should_receive(:on_login).and_call_original
          post :login, email: email, password: password
        end

        it 'should not redirect.' do
          post :login, email: email, password: password
          response.should_not be_redirect
        end
      end

      context 'controller does not have an on_login callback' do
        it 'should not invoke the callback.' do
          controller.should_not respond_to :on_login
          # Not using should_not_receive, since it defines the :on_login on the subject, defeating the purpose of test.
          post :login, email: email, password: password
        end

        it 'should redirect to the referer.' do
          post :login, email: email, password: password
          response.should redirect_to referer
        end
      end
    end
  end

  describe '#logout' do
    let!(:user) { create :user }
    before do
      session[:user_id] = user.id
      controller.set_current_user
    end

    it 'should remove the user_id from session.' do
      session[:user_id].should == user.id
      get :logout
      session[:user_id].should be_nil
    end

    it 'should unset current_user.' do
      controller.current_user.should == user
      get :logout
      controller.current_user.should be_nil
    end

    context 'controller has a logout callback' do
      before do
        class UsersController
          def on_logout
            head :ok
          end
        end
      end

      after do
        class UsersController
          remove_method :on_logout
        end
      end

      it 'should invoke the callback.' do
        controller.should_receive(:on_logout).and_call_original
        get :logout
      end

      it 'should not redirect.' do
        get :logout
        response.should_not be_redirect
      end
    end

    context 'controller does not have a logout callback' do
      it 'should not invoke the callback.' do
        controller.should_not respond_to :on_logout
        # Not using should_not_receive, since it defines the :on_logout on the subject, defeating the purpose of test.
        get :logout
      end

      it 'should redirect to the referer.' do
        get :logout
        response.should redirect_to referer
      end
    end
  end

  describe '#signup' do
    let(:email) { random_email }
    let(:password) { random_text }

    context 'success' do
      it 'should create a user.' do
        User.should_not exist email: email
        expect { post :signup, email: email, password: password }.to change { User.count }.by(1)
        User.should exist email: email
      end

      context 'controller has an on_signup callback' do
        before do
          class UsersController
            def on_signup
              head :ok
            end
          end
        end

        after do
          class UsersController
            remove_method :on_signup
          end
        end

        it 'should invoke the callback.' do
          controller.should_receive(:on_signup).and_call_original
          post :signup, email: email, password: password
        end

        it 'should not redirect.' do
          post :signup, email: email, password: password
          response.should_not be_redirect
        end
      end

      context 'controller does not have an on_signup callback' do
        it 'should not invoke the callback.' do
          controller.should_not respond_to :on_signup
          # Not using should_not_receive, since it defines the :on_signup on the subject, defeating the purpose of test.
          post :signup, email: email, password: password
        end

        it 'should redirect to the referer.' do
          post :signup, email: email, password: password
          response.should redirect_to referer
        end
      end
    end

    context 'failure' do
      let(:errors) { random_text }
      before do
        User.any_instance.stub(:save).and_return(false)
        User.any_instance.stub(:errors).and_return(errors)
      end

      it 'should not create a user.' do
        expect { post :signup, email: email, password: password }.to_not change { User.count }
      end

      it 'redirects to referring page.' do
        post :signup, email: email, password: password
        response.should redirect_to referer
      end

      it 'sets an error message.' do
        post :signup, email: email, password: password
        flash.alert.should == 'Please check email and password.'
      end
    end
  end
end

