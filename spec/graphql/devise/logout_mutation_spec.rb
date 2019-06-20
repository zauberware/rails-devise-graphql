require 'rails_helper'

RSpec.describe GraphqlSchema do 

  before{
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation logout{ 
        logout
      }
    ")
  }

  let(:password){ SecureRandom.uuid }

  describe 'logout' do
    context 'when no user exists' do
      it 'is false' do
        expect(graphql!['data']['logout']).to be false
      end
    end

    
    context 'when there\'s a matching user' do
      
      before { 
        @current_user = create(:user, email: Faker::Internet.email, password: password, password_confirmation: password)
        prepare_context({ current_user: @current_user }) 
      }

      let(:user) { 
        @current_user 
      }
      
      it 'returns user object' do
        jti_before = user.jti
        graphql!
        user.reload
        expect(user.jti).not_to eq jti_before
      end
    end
  end

end