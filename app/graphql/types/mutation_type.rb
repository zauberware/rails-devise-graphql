# frozen_string_literal: true

module Types
  # Loads mutations into schema
  # Include ither mutations here
  class MutationType < Types::BaseObject
    implements ::Types::GraphqlAuth

    # Mutations
    field :update_user, mutation: Mutations::UpdateUser
    field :update_user_role, mutation: Mutations::UpdateUserRole
    field :delete_user, mutation: Mutations::DeleteUser

    # Company
    field :update_company, mutation: Mutations::Companies::UpdateCompany
  end
end
