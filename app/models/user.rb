# frozen_string_literal: true

# User model to access application
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :devise,
         :validatable,
         :lockable,
         :trackable

  # add new roles to the end
  enum role: { user: 0, admin: 1, superadmin: 2 }

  # - VALIDATIONS
  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }

  # - CALLBACKS
  after_initialize :setup_new_user, if: :new_record?

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
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :password_confirmation
      field :role
    end

    show do
      field :id
      field :first_name
      field :last_name
      field :email
      field :role
      field :last_sign_in_at
    end
  end
  # rubocop:enable Metrics/BlockLength
  # :nocov:
end
