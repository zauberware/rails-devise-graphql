require 'rails_helper'

RSpec.describe GraphqlSchema do 

  before{
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation signUp($email: String!, $password: String!, $passwordConfirmation: String!, $firstName: String!, $lastName: String!){ 
        signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation, firstName: $firstName, lastName: $lastName) { 
          email 
        } 
      }
    ")
  }

  describe 'signUp' do

    let(:user) { build(:user) } 
    
    before{
      prepare_query_variables(
        email: user.email, 
        password: user.password,
        passwordConfirmation: user.password_confirmation,
        firstName: user.first_name,
        lastName: user.last_name
      )
    }

    it 'returns user object' do
      user_email = graphql!['data']['signUp']['email']
      expect(user_email).to eq(user.email)
    end
  end

end