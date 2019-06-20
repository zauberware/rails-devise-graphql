require 'rails_helper'

RSpec.describe GraphqlSchema do 

  before{
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
  }

  let(:password){ SecureRandom.uuid }

  describe 'login' do
    context 'when no user exists' do
      it 'is nil' do
        expect(graphql!['data']['tokenLogin']).to eq(nil)
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
        user_email = graphql!['data']['tokenLogin']['email']
        expect(user_email).to eq(user.email)
      end
    end
  end

end