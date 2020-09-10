# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::ResetPassword do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation resetPassword($password: String!, $passwordConfirmation: String!, $resetPasswordToken: String!){
        resetPassword(
          password: $password,
          passwordConfirmation: $passwordConfirmation,
          resetPasswordToken: $resetPasswordToken
        )
      }
    ")
  end

  let(:password) { SecureRandom.uuid }

  describe 'resetPassword' do
    context 'when no user exists with that token' do
      before do
        prepare_query_variables(
          password: password,
          passwordConfirmation: password,
          resetPasswordToken: 'faked'
        )
      end

      it 'returns false' do
        expect(graphql!['data']['resetPassword']).to be false
      end
    end

    context 'when user exists' do
      before  do
        @user = create(:user, reset_password_token: SecureRandom.uuid)
        prepare_query_variables(
          password: password,
          passwordConfirmation: password,
          resetPasswordToken: @user.reset_password_token
        )

        # TODO: fix rubocop
        # rubocop:disable Lint/UselessAssignment
        # Mock get user with token from devise
        with_reset_password_token = double
        allow(User).to receive(:with_reset_password_token) { @user }
        # rubocop:enable Lint/UselessAssignment
      end

      let(:user) { @user }

      it 'returns true' do
        expect(graphql!['data']['resetPassword']).to be true
      end

      it 'calls send_reset_password_instructions on user' do
        # rubocop:disable RSpec/MessageSpies
        expect(user).to receive(:reset_password).with(password, password)
        # rubocop:enable RSpec/MessageSpies
        graphql!
      end

      it 'returns false when password does NOT match confirmation' do
        prepare_query_variables(
          password: password,
          passwordConfirmation: "#{password}1",
          resetPasswordToken: @user.reset_password_token
        )
        expect(graphql!['data']['resetPassword']).to be false
      end
    end
  end
end
