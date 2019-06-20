require 'rails_helper'

RSpec.describe GraphqlSchema do
  before{
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})
  }

  describe 'me' do
    before{
      prepare_query('{
        me{
          name
        }
      }')
    }

    context 'when there\'s no current user' do
      it 'is nil' do
        expect(graphql!['data']['me']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      before{
        prepare_context({
          current_user: create(:user, first_name: 'A', last_name: 'B')
        })
      }
      it 'shows the user\'s name' do
        user_name = graphql!['data']['me']['name']
        expect(user_name).to eq('A B')
      end
    end
  end

end