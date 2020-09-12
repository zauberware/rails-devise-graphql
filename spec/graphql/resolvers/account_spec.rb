# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Account, type: :request do
  subject(:graphql!) { result }

  let(:result) do
    GraphqlSchema.execute(
      query_string,
      variables: variables,
      context: context
    )
  end

  let(:variables) do
    {}
  end

  let(:query_string) do
    <<-GRAPHQL
    query {
      account {
        id
        name
      }
    }
    GRAPHQL
  end

  describe 'account' do
    context 'when there\'s no current user' do
      let(:context) do
        {
          current_user: nil
        }
      end

      it 'returns nil' do
        graphql!
        expect(result['data']['account']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      let!(:user) do
        create(:user)
      end

      let(:context) do
        {
          current_user: user
        }
      end

      it 'returns account of user' do
        graphql!
        account_id = result['data']['account']['id']
        expect(account_id).to eq(user.account.id)
      end
    end
  end
end
