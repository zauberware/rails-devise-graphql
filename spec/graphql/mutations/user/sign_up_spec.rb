# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::SignUp do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation signUp($attributes: UserInput!){
        signUp(attributes: $attributes) {
          email
        }
      }
    ")
  end

  describe 'signUp' do
    let(:user) { build(:user) }

    before do
      prepare_query_variables(
        attributes: {
          email: user.email,
          password: user.password,
          passwordConfirmation: user.password_confirmation,
          firstName: user.first_name,
          lastName: user.last_name
        }
      )
    end

    it 'returns user object' do
      user_email = graphql!['data']['signUp']['email']
      expect(user_email).to eq(user.email)
    end
  end
end
