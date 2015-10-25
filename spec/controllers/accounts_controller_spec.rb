require 'spec_helper'

describe AccountsController, :type => :controller do
  let(:referer) { random_url }
  before { request.env['HTTP_REFERER'] = referer }

  it { expect(controller).to have_before_filter :authorize, only: [:set_password] }

  describe 'POST do_login' do
    let(:email) { random_email }
    let(:password) { random_text }

    context 'failure' do
      shared_examples_for 'login failure' do
        it 'redirects to referring page.' do
          post :do_login, email: email, password: password
          expect(response).to redirect_to referer
        end

        it 'sets an error message.' do
          post :do_login, email: email, password: password
          expect(flash.alert).to eq 'Please check email and password.'
        end
      end

      context 'when account does not exist' do
        before { expect(Account).to_not exist email: email }

        it_behaves_like 'login failure'
      end

      context 'when authentication failed' do
        before { create(:account, email: email, password: random_text) }

        it_behaves_like 'login failure'
      end
    end

    context 'success' do
      let!(:account) { create(:account, email: email, password: password) }

      it 'should set the account in the session.' do
        expect(session[:account_id]).to be_nil
        post :do_login, email: email, password: password
        expect(session[:account_id]).to eq account.id
      end

      it 'should set the current_account.' do
        expect(controller.current_account).to be_nil
        post :do_login, email: email, password: password
        expect(controller.current_account).to eq account
      end

      context 'controller has an on_login callback' do
        before do
          class AccountsController
            def on_login
              head :ok
            end
          end
        end

        after do
          class AccountsController
            remove_method :on_login
          end
        end

        it 'should invoke the callback.' do
          expect(controller).to receive(:on_login).and_call_original
          post :do_login, email: email, password: password
        end

        it 'should not redirect.' do
          post :do_login, email: email, password: password
          expect(response).to_not be_redirect
        end
      end

      context 'controller does not have an on_login callback' do
        it 'should not invoke the callback.' do
          expect(controller).to_not respond_to :on_login
          # Not using should_not_receive, since it defines the :on_login on the subject, defeating the purpose of test.
          post :do_login, email: email, password: password
        end

        context 'redirect URL is passed as query param' do
          let!(:session_redirect_url) { random_url }
          let!(:params_redirect_url) { random_url }

          before do
            session[:redirect] = session_redirect_url
          end

          it 'should redirect to the redirect URL in the query param' do
            post :do_login, email: email, password: password, redirect: params_redirect_url
            expect(response).to redirect_to params_redirect_url
          end

          it 'should delete redirect URL in the session' do
            post :do_login, email: email, password: password, redirect: params_redirect_url
            expect(session[:redirect]).to be_nil
          end
        end

        context 'redirect URL is not passed as query param but set in the session' do
          let!(:session_redirect_url) { random_url }

          before do
            session[:redirect] = session_redirect_url
          end

          it 'should redirect to the redirect URL in the session' do
            post :do_login, email: email, password: password
            expect(response).to redirect_to session_redirect_url
          end

          it 'should delete the redirect URL in the session' do
            post :do_login, email: email, password: password
            expect(session[:redirect]).to be_nil
          end
        end

        it 'should redirect to the root path if nothing is set.' do
          default_redirect_url = random_url
          allow(controller).to receive(:root_path).and_return default_redirect_url
          post :do_login, email: email, password: password
          expect(response).to redirect_to default_redirect_url
        end
      end
    end
  end

  describe 'GET login' do
    it 'is successful' do
      get :login

      expect(response).to have_http_status :success
    end

    it 'renders the default template' do
      get :login

      expect(response).to render_template 'accounts/default_login'
    end

  end

  describe 'GET logout' do
    let!(:account) { create :account }
    before do
      session[:account_id] = account.id
      controller.set_current_account
    end

    it 'should remove the account_id from session.' do
      expect(session[:account_id]).to eq account.id
      get :logout
      expect(session[:account_id]).to be_nil
    end

    it 'should unset current_account.' do
      expect(controller.current_account).to eq account
      get :logout
      expect(controller.current_account).to be_nil
    end

    context 'controller has a logout callback' do
      before do
        class AccountsController
          def on_logout
            head :ok
          end
        end
      end

      after do
        class AccountsController
          remove_method :on_logout
        end
      end

      it 'should invoke the callback.' do
        expect(controller).to receive(:on_logout).and_call_original
        get :logout
      end

      it 'should not redirect.' do
        get :logout
        expect(response).to_not be_redirect
      end
    end

    context 'controller does not have a logout callback' do
      it 'should not invoke the callback.' do
        expect(controller).to_not respond_to :on_logout
        # Not using should_not_receive, since it defines the :on_logout on the subject, defeating the purpose of test.
        get :logout
      end

      it 'should redirect to the redirect URL in query params' do
        params_redirect_url = random_url
        get :logout, redirect: params_redirect_url
        expect(response).to redirect_to params_redirect_url
      end

      it 'should redirect to the root path otherwise' do
        redirect_url = random_url
        allow(controller).to receive(:root_path).and_return redirect_url
        get :logout
        expect(response).to redirect_to redirect_url
      end
    end
  end

  describe 'POST do_signup' do
    let(:email) { random_email }
    let(:password) { random_text }

    context 'on success' do
      it 'should create a account.' do
        expect(Account).to_not exist email: email
        expect { post :do_signup, email: email, password: password }.to change { Account.count }.by(1)
        expect(Account).to exist email: email
      end

      context 'controller has an on_signup callback' do
        before do
          class AccountsController
            def on_signup
              head :ok
            end
          end
        end

        after do
          class AccountsController
            remove_method :on_signup
          end
        end

        it 'should invoke the callback.' do
          expect(controller).to receive(:on_signup).and_call_original
          post :do_signup, email: email, password: password
        end

        it 'should not redirect.' do
          post :do_signup, email: email, password: password
          expect(response).to_not be_redirect
        end
      end

      context 'controller does not have an on_signup callback' do
        it 'should not invoke the callback.' do
          expect(controller).to_not respond_to :on_signup
          # Not using should_not_receive, since it defines the :on_signup on the subject, defeating the purpose of test.
          post :do_signup, email: email, password: password
        end


        context 'redirect URL is passed as query param' do
          let!(:session_redirect_url) { random_url }
          let!(:params_redirect_url) { random_url }

          before do
            session[:redirect] = session_redirect_url
          end

          it 'should redirect to the redirect URL in the query param' do
            post :do_signup, email: email, password: password, redirect: params_redirect_url
            expect(response).to redirect_to params_redirect_url
          end

          it 'should delete redirect URL in the session' do
            post :do_signup, email: email, password: password, redirect: params_redirect_url
            expect(session[:redirect]).to be_nil
          end
        end

        context 'redirect URL is not passed as query param but set in the session' do
          let!(:session_redirect_url) { random_url }

          before do
            session[:redirect] = session_redirect_url
          end

          it 'should redirect to the redirect URL in the session' do
            post :do_signup, email: email, password: password
            expect(response).to redirect_to session_redirect_url
          end

          it 'should delete the redirect URL in the session' do
            post :do_signup, email: email, password: password
            expect(session[:redirect]).to be_nil
          end
        end

        it 'should redirect to the root path if nothing is set.' do
          default_redirect_url = random_url
          allow(controller).to receive(:root_path).and_return default_redirect_url
          post :do_signup, email: email, password: password
          expect(response).to redirect_to default_redirect_url
        end
      end
    end

    context 'on failure' do
      let(:errors) { random_text }
      before { allow_any_instance_of(Account).to receive(:save).and_return(false) }

      it 'should not create a account.' do
        expect { post :do_signup, email: email, password: password }.to_not change { Account.count }
      end

      it 'redirects to referring page.' do
        post :do_signup, email: email, password: password
        expect(response).to redirect_to referer
      end

      it 'sets an error message.' do
        post :do_signup, email: email, password: password
        expect(flash.alert).to eq 'Please check email and password.'
      end
    end
  end

  describe 'GET signup' do
    it 'is successful' do
      get :signup

      expect(response).to have_http_status :success
    end

    it 'renders the default template' do
      get :signup

      expect(response).to render_template 'accounts/default_signup'
    end
  end

  describe 'POST do_set_password' do
    let!(:old_password) { random_text }
    let!(:new_password) { random_text }
    let!(:account) { FactoryGirl.create :account, password: old_password }

    before { session[:account_id] = account.id }

    context 'passwords do not match' do
      it 'redirects to back' do
        post :do_set_password, password: random_text, password_confirmation: random_text

        expect(response).to redirect_to referer
      end

      it 'sets a message' do
        post :do_set_password, password: random_text, password_confirmation: random_text

        expect(flash[:alert]).to eq 'Passwords do not match.'
      end

      it 'does not change the password' do
        post :do_set_password, password: random_text, password_confirmation: random_text

        account.reload
        expect(account.authenticate old_password).to eq account
        expect(account.authenticate new_password).to eq false
      end

      it 'does not call on_set_password even if defined' do
        class AccountsController
          def on_set_password
          end
        end

        assert controller.respond_to?('on_set_password')

        expect(controller).to_not receive :on_set_password

        post :do_set_password, password: random_text, password_confirmation: random_text

        class AccountsController
          remove_method :on_set_password
        end
      end
    end

    context 'passwords match' do
      let!(:new_password) { random_text }

      it 'changes the account password' do
        post :do_set_password, password: new_password, password_confirmation: new_password, redirect: referer

        account.reload
        expect(account.authenticate old_password).to eq false
        expect(account.authenticate new_password).to eq account
      end

      it 'calls on_set_password when defined' do
        class AccountsController
          def on_set_password
            redirect_to :back
          end
        end

        expect(controller).to receive(:on_set_password).and_call_original

        post :do_set_password, password: new_password, password_confirmation: new_password

        class AccountsController
          remove_method :on_set_password
        end
      end

      context 'when on_set_password is not defined' do
        before { assert !controller.respond_to?(:on_set_password) }

        it 'redirects to the URL specified in redirect query parameter' do
          redirect_url = random_url
          session[:redirect] = random_url

          post :do_set_password, password: new_password, password_confirmation: new_password, redirect: redirect_url

          expect(response).to redirect_to redirect_url
        end

        it 'redirects to the redirect URL in session if query parameter is not set' do
          redirect_url = session[:redirect] = random_url

          post :do_set_password, password: new_password, password_confirmation: new_password

          expect(response).to redirect_to redirect_url
        end

        it 'redirects to root path if neither is set' do
          assert session[:redirect].nil?

          post :do_set_password, password: new_password, password_confirmation: new_password

          expect(response).to redirect_to root_path
        end
      end
    end
  end
end

