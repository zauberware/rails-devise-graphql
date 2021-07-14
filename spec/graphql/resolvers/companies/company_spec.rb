# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Companies::Company, type: :request do
  before do
    prepare_query_variables({})
    prepare_query("
      query {
        company {
          id
          name
        }
      }
    ")
  end

  describe 'company' do
    context 'when there\'s no current user' do
      it 'returns nil' do
        expect(graphql!['data']['company']).to eq(nil)
      end
    end

    context 'when there\'s a current user' do
      before do
        @user = create(:user)
        prepare_context({ current_user: @user })
      end

      it 'returns company of user' do
        company_id = graphql!['data']['company']['id']
        expect(company_id).to eq(@user.company.id)
      end
    end
  end
end
