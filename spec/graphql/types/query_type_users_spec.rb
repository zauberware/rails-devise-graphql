# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do
  subject(:graphql!) { result }

  let!(:account) do
    create(:account)
  end

  let!(:admin) do
    create(:user, :admin, account_id: account.id)
  end

  let(:result) do
    GraphqlSchema.execute(
      query_string,
      variables: variables,
      context: context
    )
  end

  let(:query_string) do
    <<-GRAPHQL
    query($after: String, $before: String, $first: Int, $last: Int) {
      users(after: $after, before: $before, first: $first, last: $last){
        pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
        }
        edges{
          node{
            id
            email
            firstName
            lastName
          }
        }
      }
    }
    GRAPHQL
  end

  let(:context) do
    { current_user: admin }
  end

  let(:variables) { {} }

  describe 'users' do
    context 'when there\'s no current user' do
      let(:context) { { current_user: nil } }

      before { create_list(:user, 3) }

      it 'returns empty Array' do
        graphql!
        expect(result['data']['users']['edges']).to be_empty
      end
    end

    context 'when there\'s a current user' do
      let(:user) { create(:user) }

      let(:context) { { current_user: user } }

      before { create_list(:user, 3, account: user.account) }

      it 'returns user in edges.' do
        graphql!
        expect(result['data']['users']['edges'].length).to eq(4)
      end

      it 'returns pageInfo' do
        graphql!
        expect(result['data']['users']['pageInfo']['startCursor']).not_to be_empty
      end
    end
  end
end
