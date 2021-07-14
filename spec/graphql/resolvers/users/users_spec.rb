# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Users::Users, type: :request do
  before do
    prepare_query_variables({})
    prepare_query("
      query($sortBy: UserSort, $filter: UserFilter, $page: Int, $limit: Int) {
        users(sortBy: $sortBy, filter: $filter, page: $page, limit: $limit){
          metadata {
            totalPages
            totalCount
            currentPage
            limitValue
          }
          collection {
            id
            firstName
            lastName
            email
            createdAt
            updatedAt
          }
        }
      }
    ")
  end

  let(:user) { create(:user) }

  describe 'users' do
    context 'when there\'s no current user' do
      before do
        User.delete_all
        prepare_context({ current_user: nil })

        create_list(:user, 3)
      end

      it 'returns error' do
        expect(graphql!['errors'][0]['message']).not_to be_empty
      end
    end

    context 'when there\'s a current user' do
      before do
        prepare_context({ current_user: user })

        create_list(:user, 3, company: user.company)
      end

      it 'returns user in collection.' do
        expect(graphql!['data']['users']['collection'].length).to eq(4) # +1 the logged in user
      end

      it 'returns metadata' do
        expect(graphql!['data']['users']['metadata']['totalCount']).not_to be_nil
      end

      it 'not has error' do
        expect(graphql!['errors']).to be_nil
      end
    end

    context 'when filters set' do
      before do
        User.delete_all
        @user = create(:user)
        prepare_context({ current_user: @user })
        prepare_query_variables({
                                  filter: {
                                    createdAt: "<= #{@user.created_at + 1.hour}"
                                  }
                                })

        Timecop.freeze(DateTime.now + 2.hours) do
          create_list(:user, 3, company: @user.company)
        end
      end

      it 'returns only filtered users' do
        users = graphql!['data']['users']['collection']
        expect(users.first['createdAt']).to eq(@user.created_at.iso8601)
      end

      it 'returns only the filtered one' do
        users = graphql!['data']['users']['collection']
        expect(users.length).to eq(4) # +1 the logged in user
      end

      it 'returns metadata' do
        expect(graphql!['data']['users']['metadata']['totalCount']).not_to be_nil
      end

      it 'not has error' do
        expect(graphql!['errors']).to be_nil
      end
    end

    context 'when sortBy set' do
      before do
        prepare_context({ current_user: user })
        prepare_query_variables({
                                  sortBy: {
                                    attribute: 'createdAt',
                                    direction: 'asc'
                                  }
                                })

        create_list(:user, 3, company: user.company)
      end

      it 'returns ordered users' do
        items = graphql!['data']['users']['collection']
        (items.length - 2).times do |i|
          expect(DateTime.parse(items[i]['createdAt']) <= DateTime.parse(items[i + 1]['createdAt'])).to be_truthy
        end
      end

      it 'returns metadata' do
        expect(graphql!['data']['users']['metadata']['totalCount']).not_to be_nil
      end

      it 'not has error' do
        expect(graphql!['errors']).to be_nil
      end
    end

    context 'when used text_search' do
      before do
        @user = create(:user)
        prepare_context({ current_user: @user })
        prepare_query_variables({
                                  filter: {
                                    textSearch: @user.first_name
                                  }
                                })
      end

      it 'returns only filtered user' do
        users = graphql!['data']['users']['collection']
        expect(users.first['firstName']).to eq(@user.first_name)
      end

      it 'returns metadata' do
        expect(graphql!['data']['users']['metadata']['totalCount']).not_to be_nil
      end

      it 'not has error' do
        expect(graphql!['errors']).to be_nil
      end
    end
  end
end
