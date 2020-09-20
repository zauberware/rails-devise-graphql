# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Users::Users, type: :request do
  subject(:graphql!) { result }

  let!(:company) do
    create(:company)
  end

  let!(:admin) do
    create(:user, :admin, company_id: company.id)
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
    query($orderBy: ItemOrder, $filter: UserFilter, $after: String, $before: String, $first: Int, $last: Int) {
      users(orderBy: $orderBy, filter: $filter, after: $after, before: $before, first: $first, last: $last){
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

      before { create_list(:user, 3, company: user.company) }

      it 'returns user in edges.' do
        graphql!
        expect(result['data']['users']['edges'].length).to eq(4)
      end

      it 'returns pageInfo' do
        graphql!
        expect(result['data']['users']['pageInfo']['startCursor']).not_to be_empty
      end
    end

    context 'when filters set' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }

      let(:context) { { current_user: user } }

      let(:variables) do
        {
          filter: {
            firstName: user.first_name
          }
        }
      end

      before { create_list(:user, 3, company: user.company) }

      it 'returns only filtered user' do
        graphql!
        users = result['data']['users']['edges']
        expect(users.first['node']['id']).to eq(user.id)
      end

      it 'returns only the filterd one' do
        graphql!
        users = result['data']['users']['edges']
        expect(users.length).to eq(1)
      end

      it 'returns pageInfo' do
        graphql!
        expect(result['data']['users']['pageInfo']['startCursor']).not_to be_empty
      end

      it 'not has errors' do
        graphql!
        expect(result['errors']).to be_nil
      end
    end

    context 'when orderBy set' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }

      let(:context) { { current_user: user } }

      let(:variables) do
        {
          orderBy: {
            attribute: 'first_name',
            direction: 'asc'
          }
        }
      end

      before { create_list(:user, 20, company: user.company) }

      it 'returns ordered users' do
        graphql!
        users = result['data']['users']['edges']
        (users.length - 2).times do |i|
          expect(users[i]['node']['firstName'][0] <= users[i + 1]['node']['firstName'][0]).to be_truthy
        end
      end

      it 'returns pageInfo' do
        graphql!
        expect(result['data']['users']['pageInfo']['startCursor']).not_to be_empty
      end

      it 'not has errors' do
        graphql!
        expect(result['errors']).to be_nil
      end
    end
  end
end
