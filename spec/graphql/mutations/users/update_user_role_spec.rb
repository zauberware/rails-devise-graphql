# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::UpdateUserRole do
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
    mutation updateUserRole($id: ID!, $role: String!){
      updateUserRole(id: $id, role: $role)
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
          role: 'admin'
        }
      end

      it 'returns errors' do
        graphql!
        message = result['errors'][0]['message']
        expect(message).not_to be_nil
      end

      it 'not updates user role' do
        graphql!
        expect(user.role).to eq('user')
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
          role: 'admin'
        }
      end

      it 'returns errors' do
        graphql!
        message = result['data']['updateUserRolw']
        expect(message).to be_nil
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
          role: 'superadmin'
        }
      end

      it 'returns false' do
        graphql!
        success = result['data']['updateUserRole']
        expect(success).to eq(false)
      end

      it 'not updates user role' do
        graphql!
        expect(user.role).to eq('user')
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
          role: 'admin'
        }
      end

      it 'returns true' do
        graphql!
        success = result['data']['updateUserRole']
        expect(success).to eq(true)
      end

      it 'updates user role' do
        graphql!
        expect(user.reload.role).to eq('admin')
      end
    end
  end
end
