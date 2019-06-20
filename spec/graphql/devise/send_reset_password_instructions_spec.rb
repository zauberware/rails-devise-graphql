require 'rails_helper'

RSpec.describe GraphqlSchema do 

  before{
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation sendResetPasswordInstructions($email: String!){ 
        sendResetPasswordInstructions(email: $email)
      }
    ")
  }

  describe 'sendResetPasswordInstructions' do
    context 'when no user exists' do
      before{
        prepare_query_variables(
          email: Faker::Internet.email,
        )
      }
      
      it 'returns always true' do
        expect(graphql!['data']['sendResetPasswordInstructions']).to be true
      end
    end

    context 'when user exists' do
      before{
        @user = create(:user)
        prepare_query_variables(
          email: @user.email,
        )
      }

      let(:user) { @user }
      
      it 'returns true' do
        expect(graphql!['data']['sendResetPasswordInstructions']).to be true
      end

      it 'calls send_reset_password_instructions on user' do
        allow_any_instance_of(User).to receive(:send_reset_password_instructions)
        graphql!
      end
    end
  end
end