# frozen_string_literal: true

module Types
  # Loads mutations into schema
  # Include ither mutations here
  class MutationType < Types::BaseObject
    implements ::Types::GraphqlAuth

    # Mutations
    field :update_user, mutation: Mutations::Users::UpdateUser
    field :update_user_role, mutation: Mutations::Users::UpdateUserRole
    field :delete_user, mutation: Mutations::Users::DeleteUser
    field :invite_user, mutation: Mutations::Users::InviteUser
    field :accept_invite, mutation: Mutations::Users::AcceptInvite

    # Company
    field :update_company, mutation: Mutations::Companies::UpdateCompany
  end
end
