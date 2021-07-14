# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::DeleteUser do
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
    mutation deleteUser($id: ID!){
      deleteUser(id: $id)
    }
    GRAPHQL
  end

  describe 'deleteUser' do
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
          id: user.id
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
          id: 'wrong'
        }
      end

      it 'returns nil' do
        graphql!
        success = result['data']['deleteUser']
        expect(success).to be_nil
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
          id: user.id
        }
      end

      it 'changes name' do
        graphql!
        success = result['data']['deleteUser']
        expect(success).to eq(true)
      end
    end
  end
end
