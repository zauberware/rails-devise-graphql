# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Companies::UpdateCompany do
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
    mutation updateCompany($id: ID!, $attributes: CompanyInput!){
      updateCompany(id: $id, attributes: $attributes) {
        id
        name
      }
    }
    GRAPHQL
  end

  describe 'updateCompany' do
    context 'with invalid company id' do
      let!(:user) do
        create(:user)
      end

      let(:context) do
        {
          current_user: user
        }
      end

      let(:variables) do
        {
          id: 'wrong',
          attributes: {}
        }
      end

      it 'returns errors' do
        message = result['errors'][0]['message']
        expect(message).not_to be_nil
      end
    end

    context 'with invalid params' do
      let!(:user) do
        create(:user)
      end

      let(:context) do
        {
          current_user: user
        }
      end

      let(:variables) do
        {
          id: user.company_id,
          attributes: {}
        }
      end

      it 'returns errors' do
        graphql!
        message = result['errors'][0]['message']
        expect(message).not_to be_nil
      end
    end

    context 'with valid params' do
      let!(:user) do
        create(:user, :admin)
      end

      let(:context) do
        {
          current_user: user
        }
      end

      let(:variables) do
        {
          id: user.company_id,
          attributes: { name: 'new name' }
        }
      end

      it 'changes name' do
        graphql!
        name = result['data']['updateCompany']['name']
        expect(name).to eq('new name')
      end
    end
  end
end
