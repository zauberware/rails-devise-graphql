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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :registerable,
         :recoverable,
         :confirmable,
         :devise,
         :validatable,
         :lockable,
         :trackable,
         :invitable

  # add new roles to the end
  enum role: { user: 0, admin: 1, superadmin: 2 }

  # - VALIDATIONS
  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }

  # - RELATIONS
  belongs_to :company, counter_cache: true, class_name: 'Companies::Company'

  # - CALLBACKS
  after_initialize :setup_new_user, if: :new_record?
  before_validation :setup_company

  # return first and lastname
  def name
    [first_name, last_name].join(' ').strip
  end

  def status_color
    return 'warning' if role == 'admin'
    return 'danger' if role == 'superadmin'

    'primary'
  end

  private

  def setup_company
    return unless company.nil?

    self.company = Companies::Company.create!(name: 'My company')
    self.role = :admin # make this user the admin
  end

  def setup_new_user
    self.role ||= :user
  end

  # :nocov:
  # rubocop:disable Metrics/BlockLength
  rails_admin do
    weight 10
    navigation_icon 'fa fa-user-circle'

    configure :role do
      pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
        bindings[:view].tag.span(
          User.human_attribute_name(value), class: "label label-#{bindings[:object].status_color}"
        )
      end
      export_value do
        User.human_attribute_name(value)
      end
    end

    configure :email do
      pretty_value do
        bindings[:view].link_to(value, "mailto:#{value}")
      end
      export_value do
        value
      end
    end

    list do
      field :id
      field :first_name
      field :last_name
      field :email
      field :role
      field :last_sign_in_at
      field :company
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :password_confirmation
      field :role
      field :company
    end

    show do
      field :id
      field :first_name
      field :last_name
      field :email
      field :role
      field :last_sign_in_at
      field :company
    end
  end
  # rubocop:enable Metrics/BlockLength
  # :nocov:
end
