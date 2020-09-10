# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::Logout do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation logout{
        logout
      }
    ")
  end

  let(:password) { SecureRandom.uuid }

  describe 'logout' do
    context 'when no user exists' do
      it 'is false' do
        expect(graphql!['data']['logout']).to be false
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
        jti_before = current_user.jti
        graphql!
        current_user.reload
        expect(current_user.jti).not_to eq jti_before
      end
    end
  end
end
