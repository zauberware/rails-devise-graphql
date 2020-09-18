# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Companies::Company, type: :request do
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
      company {
        id
        name
      }
    }
    GRAPHQL
  end

  describe 'company' do
    context 'when there\'s no current user' do
      let(:context) do
        {
          current_user: nil
        }
      end

      it 'returns nil' do
        graphql!
        expect(result['data']['company']).to eq(nil)
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

      it 'returns company of user' do
        graphql!
        company_id = result['data']['company']['id']
        expect(company_id).to eq(user.company.id)
      end
    end
  end
end
