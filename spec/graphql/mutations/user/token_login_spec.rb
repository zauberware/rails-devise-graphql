# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::TokenLogin do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation tokenLogin{
        tokenLogin {
          email
        }
      }
    ")
  end

  let(:password) { SecureRandom.uuid }

  describe 'login' do
    context 'when no user exists' do
      it 'is nil' do
        expect(graphql!['data']['tokenLogin']).to eq(nil)
      end
    end

    context 'when there\'s a matching user' do
      let(:current_user) do
        create(
          :user,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        )
      end

      before do
        prepare_context({ current_user: current_user })
      end

      it 'returns user object' do
        user_email = graphql!['data']['tokenLogin']['email']
        expect(user_email).to eq(current_user.email)
      end
    end
  end
end
