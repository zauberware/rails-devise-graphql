# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  login_user # access current user with @current_user

  describe 'execute' do
    let(:current_user) { @current_user }

    it 'responds with a valid graphql response' do
      post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}" }
      response_body = JSON.parse(response.body)
      expect(response_body).to eq(
        { 'data' => { 'me' => { 'email' => current_user.email } } }
      )
    end

    context 'when wrong query params given' do
      it 'returns with errors' do
        post :execute, params: { 'query' => "{\n  wrong {\n    email\n  }\n}" }
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).not_to be nil
      end
    end

    # TODO: better vairales test
    context 'when using String variables' do
      it 'returns with valid graphql response' do
        post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}", 'variables' => '{ "Test": "Me" }' }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          { 'data' => { 'me' => { 'email' => current_user.email } } }
        )
      end
    end

    context 'when using empty String variables' do
      it 'returns with valid graphql response' do
        post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}", 'variables' => '' }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          { 'data' => { 'me' => { 'email' => current_user.email } } }
        )
      end
    end

    context 'when using Hash variables' do
      it 'returns with valid graphql response' do
        post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}", 'variables' => { 'Test' => 'Me' } }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          { 'data' => { 'me' => { 'email' => current_user.email } } }
        )
      end
    end

    context 'when variables are invalid' do
      it 'raises argument error' do
        expect do
          post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}", 'variables' => 12 }
        end.to raise_error
      end

      it 'calls the local logger when environment is development' do
        Rails.env = 'development'
        expect do
          post :execute, params: { 'query' => "{\n  me {\n    email\n  }\n}", 'variables' => 12 }
        end.not_to raise_error
        Rails.env = 'test'
      end
    end
  end
end
