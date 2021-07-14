# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Users::Me, type: :request do
  before do
    prepare_query_variables({})
    prepare_query("
      query {
        me {
          name
          isConfirmed
          isLocked
        }
      }
    ")
  end

  describe 'me' do
    context 'when there\'s no current user' do
      it 'is nil' do
        expect(graphql!['data']['me']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      before do
        user = create(
          :user,
          first_name: 'A',
          last_name: 'B'
        )
        prepare_context({ current_user: user })
      end

      it 'shows the user\'s name' do
        user_name = graphql!['data']['me']['name']
        expect(user_name).to eq('A B')
      end
    end
  end
end
