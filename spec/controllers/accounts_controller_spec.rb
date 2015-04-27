require 'spec_helper'

describe AccountsController, :type => :controller do
  let(:referer) { random_url }
  before { request.env['HTTP_REFERER'] = referer }

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

  describe 'GET do_logout' do
    let!(:account) { create :account }
    before do
      session[:account_id] = account.id
      controller.set_current_account
    end

    it 'should remove the account_id from session.' do
      expect(session[:account_id]).to eq account.id
      get :do_logout
      expect(session[:account_id]).to be_nil
    end

    it 'should unset current_account.' do
      expect(controller.current_account).to eq account
      get :do_logout
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
        get :do_logout
      end

      it 'should not redirect.' do
        get :do_logout
        expect(response).to_not be_redirect
      end
    end

    context 'controller does not have a logout callback' do
      it 'should not invoke the callback.' do
        expect(controller).to_not respond_to :on_logout
        # Not using should_not_receive, since it defines the :on_logout on the subject, defeating the purpose of test.
        get :do_logout
      end

      it 'should redirect to the redirect URL in query params' do
        params_redirect_url = random_url
        get :do_logout, redirect: params_redirect_url
        expect(response).to redirect_to params_redirect_url
      end

      it 'should redirect to the root path otherwise' do
        redirect_url = random_url
        allow(controller).to receive(:root_path).and_return redirect_url
        get :do_logout
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
end

