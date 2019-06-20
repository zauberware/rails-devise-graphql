require 'rails_helper'

RSpec.describe GraphqlSchema do 

  before{
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
  }

  let (:password) { SecureRandom.uuid }

  describe 'update' do
    
    context 'when no user exists' do
      before{
        prepare_query_variables(
          password: password, 
          password_confirmation: password
        )
      }
      it 'is nil' do
        expect(graphql!['data']['updateUser']).to eq(nil)
      end
    end

    
    context 'when there\'s a matching user' do
      before { 
        @current_user = create(
          :user, 
          email: Faker::Internet.email, 
          password: password, 
          password_confirmation: password
        )
        prepare_context({ current_user: @current_user }) 
      }

      let(:user) { 
        @current_user 
      }

      context 'when password matches confirmation' do
        before { 
          prepare_query_variables(
            password: password, 
            passwordConfirmation: password
          ) 
        }
        
        it 'returns user object' do
          user_email = graphql!['data']['updateUser']['email']
          expect(user_email).to eq(user.email)
        end
      end


      context 'when password does NOT match confirmation' do
        before {
          prepare_query_variables(
            password: password, 
            passwordConfirmation: password+'1'
          ) 
        }
        
        it 'returns error' do
          expect(graphql!['errors']).not_to eq nil
        end
      end


    end
  end

end