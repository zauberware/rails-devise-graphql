# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  login_user # access current user with @current_user

  describe 'execute' do
    let(:current_user) { @current_user }

    context 'when wrong query params given' do
      it 'returns with errors' do
        post :execute, params: { 'query' => "{\n  wrong {\n    email\n  }\n}" }
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).not_to be nil
      end
    end
  end
end
