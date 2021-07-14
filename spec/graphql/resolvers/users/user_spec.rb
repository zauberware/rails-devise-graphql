# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Users::User, type: :request do
  before do
    prepare_query_variables({})
    prepare_query("
      query($id: ID!) {
        user(id: $id){
          id
          email
          firstName
          lastName
        }
      }
    ")

    @company = create(:company)
    @admin = create(:user, :admin, company_id: @company.id)
    prepare_context({ current_user: @admin })
  end

  describe 'user' do
    context 'when user is not member of this company' do
      before do
        user = create(:user, company: create(:company))
        prepare_query_variables({ id: user.id })
      end

      it 'returns' do
        expect(graphql!['data']['user']).to eq(nil)
      end
    end

    context 'when user is admin of this company' do
      before do
        @user = create(:user, company: @company)
        prepare_query_variables({ id: @user.id })
      end

      it 'can access users profile' do
        user_email = graphql!['data']['user']['email']
        expect(user_email).to eq(@user.email)
      end
    end

    context 'when user is member of this company' do
      before do
        user1 = create(:user, company: @company)
        @user2 = create(:user, company: @company)
        prepare_context({ current_user: user1 })
        prepare_query_variables({ id: @user2.id })
      end

      it 'can access users profile' do
        user_email = graphql!['data']['user']['email']
        expect(user_email).to eq(@user2.email)
      end
    end
  end
end
