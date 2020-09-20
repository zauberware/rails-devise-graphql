# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Users::Me, type: :request do
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
      me {
        name
        isConfirmed
        isLocked
      }
    }
    GRAPHQL
  end

  describe 'me' do
    context 'when there\'s no current user' do
      let(:context) do
        {
          current_user: nil
        }
      end

      it 'is nil' do
        graphql!
        expect(result['data']['me']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      let!(:user) do
        create(
          :user,
          first_name: 'A',
          last_name: 'B'
        )
      end

      let(:context) do
        {
          current_user: user
        }
      end

      it 'shows the user\'s name' do
        graphql!
        user_name = result['data']['me']['name']
        expect(user_name).to eq('A B')
      end
    end
  end
end
