# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::UpdateUser do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query('
      mutation updateUser($password: String, $passwordConfirmation: String){
        updateUser(password: $password, passwordConfirmation: $passwordConfirmation) {
          email
        }
      }
    ')
  end

  let(:password) { SecureRandom.uuid }

  describe 'update' do
    context 'when no user exists' do
      before do
        prepare_query_variables(
          password: password,
          password_confirmation: password
        )
      end

      it 'is nil' do
        expect(graphql!['data']['updateUser']).to eq(nil)
      end
    end

    context 'when password matches confirmation' do
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
        prepare_query_variables(
          password: password,
          passwordConfirmation: password
        )
      end

      it 'returns user object' do
        user_email = graphql!['data']['updateUser']['email']
        expect(user_email).to eq(current_user.email)
      end
    end

    context 'when password does NOT match confirmation' do
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
        prepare_query_variables(
          password: password,
          passwordConfirmation: "#{password}1"
        )
      end

      it 'returns error' do
        expect(graphql!['errors']).not_to eq nil
      end
    end
  end
end
