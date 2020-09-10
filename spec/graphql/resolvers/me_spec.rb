# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Me do
  before do
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})
  end

  describe 'me' do
    before do
      prepare_query('{
        me{
          name
        }
      }')
    end

    context 'when there\'s no current user' do
      it 'is nil' do
        expect(graphql!['data']['me']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      before do
        prepare_context({
                          current_user: create(:user, first_name: 'A', last_name: 'B')
                        })
      end

      it 'shows the user\'s name' do
        user_name = graphql!['data']['me']['name']
        expect(user_name).to eq('A B')
      end
    end
  end
end
