# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string           default(""), not null
#  last_seen_at           :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  refresh_token          :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :uuid
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_confirmation_token                 (confirmation_token) UNIQUE
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_refresh_token                      (refresh_token) UNIQUE
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#  index_users_on_unlock_token                       (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
    expect(create(:user, :user)).to be_valid
    expect(create(:user, :admin)).to be_valid
  end

  # Validations
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to allow_value('email@address.foo').for(:email) }
  it { is_expected.not_to allow_value('email').for(:email) }
  it { is_expected.not_to allow_value('email@domain').for(:email) }
  it { is_expected.not_to allow_value('email@domain.').for(:email) }
  it { is_expected.not_to allow_value('email@domain.a').for(:email) }

  # Callbacks
  describe '#setup_new_user' do
    let(:user) { build(:user) }

    it 'sets role to user' do
      expect(user.role).to eq 'user'
    end
  end

  describe '#setup_company' do
    context 'when company is not set' do
      let(:user) { create(:user, company: nil) }

      it 'creates a new company' do
        expect(user.company).not_to be_nil
      end

      it 'makes this user an admin' do
        expect(user.role).to eq 'admin'
      end
    end

    context 'when company is set' do
      let(:user) { create(:user) }

      it 'has a company' do
        expect(user.company).not_to be_nil
      end

      it 'gives user role' do
        expect(user.role).to eq 'user'
      end
    end
  end

  # Methods
  describe '#name' do
    it 'returns first and lastname' do
      expect(create(:user, first_name: 'A', last_name: 'B').name).to eq 'A B'
    end
  end
end
