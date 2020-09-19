# frozen_string_literal: true

require 'rails_helper'

describe Rack::Attack do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  before do
    described_class.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  (1..3).each do |level|
    describe "Throttle all requests by IP (Level #{level})" do
      let(:limit) { (ENV['ATTACK_REQUEST_LIMIT'] || 300).to_i * level }
      let(:period) { (ENV['ATTACK_REQUEST_PERIOD_IN_MINUTES'] || 5).to_i**level }

      context "when requests are lower than level #{level} limit" do
        it 'does not change the request status' do
          ip = Faker::Internet.ip_v4_address
          limit.times do |i|
            Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
              get '/', session: { 'REMOTE_ADDR' => ip }
              expect(last_response.status).not_to eq(429)
            end
          end
        end
      end

      context "when requests are higher than level #{level} limit" do
        it 'changes the request status to 429' do
          ip = Faker::Internet.ip_v4_address
          (limit * 2.0).to_i.times do |i|
            Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
              get '/', session: { 'REMOTE_ADDR' => ip }
              expect(last_response.status).to eq(429) if i >= limit * 2.0
            end
          end
        end
      end
    end

    describe "Throttle all authenticated requests by IP (Level #{level})" do
      let(:limit) { (ENV['ATTACK_AUTHENTICATED_REQUEST_LIMIT'] || 300).to_i * level }
      let(:period) { (ENV['ATTACK_AUTHENTICATED_REQUEST_PERIOD_IN_MINUTES'] || 5).to_i**level }
      let(:user) { create(:user) }

      before { allow(described_class).to receive(:user_session?) { user } }

      context "when requests are lower than level #{level} limit" do
        it 'does not change the request status' do
          ip = Faker::Internet.ip_v4_address
          limit.times do |i|
            Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
              get '/', session: { 'REMOTE_ADDR' => ip }
              expect(last_response.status).not_to eq(429)
            end
          end
        end
      end

      context "when requests are higher than level #{level} limit" do
        it 'changes the request status to 429' do
          ip = Faker::Internet.ip_v4_address
          (limit * 2.0).to_i.times do |i|
            Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
              get '/', session: { 'REMOTE_ADDR' => ip }
              expect(last_response.status).to eq(429) if i >= limit * 2.0
            end
          end
        end
      end
    end

    describe "Throttle devise sign in requests (Level #{level})" do
      let(:limit) { (ENV['ATTACK_AUTH_LIMIT'] || 10).to_i * level }
      let(:period) { (ENV['ATTACK_AUTH_PERIOD_IN_MINUTES'] || 10).to_i**level }
      let(:user) { create(:user) }

      before { allow(described_class).to receive(:user_session?) { user } }

      context "when requests are lower than level #{level} limit" do
        it 'does not change the request status' do
          ip = Faker::Internet.ip_v4_address
          limit.times do |i|
            Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
              post '/users/sign_in', params: { user: { email: user.email, password: 'wrong' } }, 'REMOTE_ADDR' => ip
              expect(last_response.status).not_to eq(429)
            end
          end
        end
      end

      context "when requests are higher than level #{level} limit" do
        it 'changes the request status to 429' do
          ip = Faker::Internet.ip_v4_address
          (limit * 2.0).to_i.times do |i|
            Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
              post '/users/sign_in', params: { user: { email: user.email, password: 'wrong' } }, 'REMOTE_ADDR' => ip
              expect(last_response.status).to eq(429) if i >= limit * 2.0
            end
          end
        end
      end
    end

    describe "Throttle devise password requests (Level #{level})" do
      let(:limit) { (ENV['ATTACK_AUTH_LIMIT'] || 10).to_i * level }
      let(:period) { (ENV['ATTACK_AUTH_PERIOD_IN_MINUTES'] || 10).to_i**level }
      let(:user) { create(:user) }

      before { allow(described_class).to receive(:user_session?) { user } }

      context "when requests are lower than level #{level} limit" do
        it 'does not change the request status' do
          ip = Faker::Internet.ip_v4_address
          limit.times do |i|
            Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
              post '/users/password', params: { user: { email: user.email } }, 'REMOTE_ADDR' => ip
              expect(last_response.status).not_to eq(429)
            end
          end
        end
      end

      context "when requests are higher than level #{level} limit" do
        it 'changes the request status to 429' do
          ip = Faker::Internet.ip_v4_address
          (limit * 2.0).to_i.times do |i|
            Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
              post '/users/password', params: { user: { email: user.email } }, 'REMOTE_ADDR' => ip
              expect(last_response.status).to eq(429) if i >= limit * 2.0
            end
          end
        end
      end
    end

    describe "Throttle graphQL auth requests (Level #{level})" do
      let(:limit) { (ENV['ATTACK_AUTH_LIMIT'] || 10).to_i * level }
      let(:period) { (ENV['ATTACK_AUTH_PERIOD_IN_MINUTES'] || 10).to_i**level }
      let(:user) { create(:user) }

      before { allow(described_class).to receive(:user_session?) { user } }

      context "when requests are lower than level #{level} limit" do
        it 'does not change the request status' do
          ip = Faker::Internet.ip_v4_address
          limit.times do |i|
            Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
              post '/graphql', params: { query: 'signUp' }, 'REMOTE_ADDR' => ip
              expect(last_response.status).not_to eq(429)
            end
          end
        end
      end

      context "when requests are higher than level #{level} limit" do
        it 'changes the request status to 429' do
          ip = Faker::Internet.ip_v4_address
          (limit * 2.0).to_i.times do |i|
            Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
              post '/graphql', params: { query: 'signUp' }, 'REMOTE_ADDR' => ip
              expect(last_response.status).to eq(429) if i >= limit * 2.0
            end
          end
        end
      end
    end
  end

  describe 'Throttle graphQL actions' do
    let(:limit) { (ENV['ATTACK_PUBLIC_ACTION_LIMIT'] || 30).to_i }
    let(:period) { (ENV['ATTACK_PUBLIC_ACTION_PERIOD_IN_MINUTES'] || 60).to_i }
    let(:user) { create(:user) }

    before { allow(described_class).to receive(:user_session?) { user } }

    context 'when requests are lower than limit' do
      it 'does not change the request status' do
        ip = Faker::Internet.ip_v4_address
        limit.times do |i|
          Timecop.freeze(DateTime.now + ((i + 1) * (60 / (limit / period.to_f))).seconds) do
            post '/graphql', params: { query: 'createMessage' }, 'REMOTE_ADDR' => ip
            expect(last_response.status).not_to eq(429)
          end
        end
      end
    end

    context 'when requests are higher than limit' do
      it 'changes the request status to 429' do
        ip = Faker::Internet.ip_v4_address
        (limit * 2.0).to_i.times do |i|
          Timecop.freeze(DateTime.now + (i * (60 / ((limit * 2.0) / period.to_f))).seconds) do
            post '/graphql', params: { query: 'createMessage' }, 'REMOTE_ADDR' => ip
            expect(last_response.status).to eq(429) if i >= limit * 2.0
          end
        end
      end
    end
  end
end
