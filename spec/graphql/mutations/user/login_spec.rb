# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::Login do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation login($email: String!, $password: String!){
        login(email: $email, password: $password) {
          email
        }
      }
    ")
  end

  let(:password) { SecureRandom.uuid }

  describe 'login' do
    context 'when no user exists' do
      before do
        prepare_query_variables(
          email: Faker::Internet.email,
          password: password
        )
      end

      it 'is nil' do
        expect(graphql!['data']['login']).to eq(nil)
      end
    end

    context 'when there\'s a matching user' do
      let(:user) do
        create(
          :user,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        )
      end

      before do
        prepare_query_variables(email: user.email, password: password)
      end

      it 'returns user object' do
        user_email = graphql!['data']['login']['email']
        expect(user_email).to eq(user.email)
      end
    end
  end
end
