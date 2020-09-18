# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::UpdateUser do
  subject(:graphql!) { result }

  let!(:admin) do
    create(:user, :admin)
  end

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
    mutation updateUser($id: ID!, $attributes: UserInput!){
      updateUser(id: $id, attributes: $attributes) {
        id
        firstName
        lastName
        email
      }
    }
    GRAPHQL
  end

  describe 'updateUser' do
    context 'when not an admin' do
      let(:user) do
        create(:user, company_id: admin.company_id)
      end

      let(:context) do
        {
          current_user: user
        }
      end

      let(:variables) do
        {
          id: user.id,
          attributes: {
            email: 'mail@pete.de',
            lastName: 'new last name',
            firstName: 'new first name'
          }
        }
      end

      it 'returns errors' do
        graphql!
        message = result['errors'][0]['message']
        expect(message).not_to be_nil
      end
    end

    context 'with invalid id' do
      let(:user) do
        create(:user, company_id: admin.company_id)
      end

      let(:context) do
        {
          current_user: admin
        }
      end

      let(:variables) do
        {
          id: 'wrong',
          attributes: {}
        }
      end

      it 'returns errors' do
        graphql!
        message = result['errors'][0]['message']
        expect(message).not_to be_nil
      end
    end

    context 'with invalid params' do
      let(:user) do
        create(:user, company_id: admin.company_id)
      end

      let(:context) do
        {
          current_user: admin
        }
      end

      let(:variables) do
        {
          id: user.id,
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
        create(:user, company_id: admin.company_id)
      end

      let(:context) do
        {
          current_user: admin
        }
      end

      let(:variables) do
        {
          id: user.id,
          attributes: {
            email: 'mail@pete.de',
            lastName: 'new last name',
            firstName: 'new first name'
          }
        }
      end

      it 'changes name' do
        graphql!
        name = result['data']['updateUser']['firstName']
        expect(name).to eq('new first name')
      end
    end
  end
end
