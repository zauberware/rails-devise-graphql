# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::SendResetPasswordInstructions do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation sendResetPasswordInstructions($email: String!){
        sendResetPasswordInstructions(email: $email)
      }
    ")
  end

  describe 'sendResetPasswordInstructions' do
    context 'when no user exists' do
      before do
        prepare_query_variables(
          email: Faker::Internet.email
        )
      end

      it 'returns always true' do
        expect(graphql!['data']['sendResetPasswordInstructions']).to be true
      end
    end

    context 'when user exists' do
      before  do
        @user = create(:user)
        prepare_query_variables(
          email: @user.email
        )
      end

      let(:user) { @user }

      it 'returns true' do
        expect(graphql!['data']['sendResetPasswordInstructions']).to be true
      end

      it 'calls send_reset_password_instructions on user' do
        # TODO: fix rubocop
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(User).to receive(:send_reset_password_instructions)
        # rubocop:enable RSpec/AnyInstance
        graphql!
      end
    end
  end
end
