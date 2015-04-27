require 'spec_helper'

describe ApplicationController, :type => :controller do
  it { should have_before_filter(:set_current_account) }

  describe '#authorize' do
    context 'for actions exempt from authorization' do
      ['do_login', 'login', 'do_logout', 'do_signup', 'signup'].each do |action|
        context "accounts##{action}" do
          let(:params) { {:controller => 'accounts', :action => action} }
          before { allow(controller).to receive(:params).and_return(params) }

          shared_examples_for '#authorize for actions that do not require authorization' do
            before { allow(controller).to receive(:params).and_return(:controller => 'accounts', :action => 'do_login') }

            it 'does not redirect' do
              expect(controller).to_not receive(:redirect_to)
              controller.send(:authorize)
            end

            it 'does not set session return to address' do
              expect(session[:redirect]).to be_nil
              controller.send(:authorize)
              expect(session[:redirect_to]).to be_nil
            end

            it 'returns true' do
              expect(controller.send :authorize).to eq true
            end
          end

          context 'when there is a current account' do
            before do
              session[:account_id] = create(:account).to_param
              controller.send(:set_current_account)
            end

            it_should_behave_like '#authorize for actions that do not require authorization'
          end

          context 'when there is no current account' do
            before { session.delete(:account_id) }

            it_should_behave_like '#authorize for actions that do not require authorization'
          end
        end
      end
    end

    context 'for actions that require authorization' do
      before { allow(controller).to receive(:params).and_return({:controller => 'sales', :action => 'recent'}) }

      shared_examples_for '#authorize for accounts#do_login' do
        before { allow(controller).to receive(:params).and_return(:controller => 'accounts', :action => 'do_login') }

        it 'does not redirect.' do
          expect(controller).to_not receive(:redirect_to)
          controller.send(:authorize)
        end

        it 'returns true' do
          expect(controller.send :authorize).to eq true
        end
      end

      context 'when there is a current account' do
        before do
          session[:account_id] = create(:account).to_param
          controller.send(:set_current_account)
        end

        it 'does not redirect' do
          expect(controller).to_not receive(:redirect_to)
          controller.send(:authorize)
        end

        it 'returns true' do
          expect(controller.send :authorize).to eq true
        end

        it 'does not set session return to address.' do
          expect(session[:redirect]).to be_nil
          controller.send(:authorize)
          expect(session[:redirect_to]).to be_nil
        end
      end

      context 'when there is no current account' do
        before { session.delete(:account_id) }

        it 'redirects to the login page with an alert' do
          expect(controller).to receive(:redirect_to)
          controller.send(:authorize)
        end

        it 'sets the redirect URL in session to be the current page.' do
          allow(controller).to receive(:redirect_to)

          expect(session[:redirect]).to be_nil
          controller.send(:authorize)
          expect(session[:redirect]).to eq recent_sales_url
        end
      end
    end
  end

  describe '#set_current_account' do
    context 'session[:account_id] is set' do
      let!(:account) { create :account }
      before { session[:account_id] = account.id }

      it 'should set current account if it is nil (and return true).' do
        expect(controller.current_account).to be_nil
        expect(controller.send :set_current_account).to eq true
        expect(controller.current_account).to eq account
      end

      it 'should reset current account if it is set to some other account (and return true).' do
        other = create :account
        controller.instance_variable_set('@current_account', other)

        expect(controller.current_account).to eq other
        expect(controller.send :set_current_account).to eq true
        expect(controller.current_account).to eq account
      end

      it 'should keep current account if it is already set to account (and return true).' do
        controller.instance_variable_set('@current_account', account)

        expect(controller.current_account).to eq account
        expect(controller.send :set_current_account).to eq true
        expect(controller.current_account).to eq account
      end
    end

    context 'session[:account_id] is not set' do
      before { session[:account_id] = nil }

      it 'should keep current account if it is nil (and return true).' do
        expect(controller.current_account).to be_nil
        expect(controller.send :set_current_account).to eq true
        expect(controller.current_account).to be_nil
      end

      it 'should set current account to nil if it is set (and return true).' do
        controller.instance_variable_set('@current_account', create(:account))

        expect(controller.current_account).to_not be_nil
        expect(controller.send :set_current_account).to eq true
        expect(controller.current_account).to be_nil
      end
    end
  end
end