# frozen_string_literal: true

module Resolvers
  module Users
    # Resolver to return a user
    class Users < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::Users::UserType.connection_type, null: false
      description 'Returns all user for the current user company'
      scope { resources }

      def resources
        ::User.accessible_by(current_ability).includes(:company)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[email first_name last_name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class UserFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :email, String, required: false
        argument :first_name, String, required: false
        argument :last_name, String, required: false
      end
      option :filter, type: UserFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[email first_name last_name]
      end
    end
  end
end
