# frozen_string_literal: true

module Types
  module Users
    # GraphQL type for a user
    class UserType < Types::BaseModel
      field :name, String, null: false
      field :first_name, String, null: false
      field :last_name, String, null: false
      field :email, String, null: true
      field :role, String, null: false
      field :company, Types::Companies::CompanyType, null: false

      field :is_confirmed, Boolean, null: false
      def is_confirmed
        object.confirmed?
      end

      field :is_locked, Boolean, null: false
      def is_locked
        object.access_locked?
      end
    end
  end
end
