module Types
  class MutationType < Types::BaseObject
    
    # Authentication
    field :login, mutation: Mutations::User::Login
    field :token_login, mutation: Mutations::User::TokenLogin
    field :logout, mutation: Mutations::User::Logout
    field :update_user, mutation: Mutations::User::UpdateUser
    field :sign_up, mutation: Mutations::User::SignUp
    field :reset_password, mutation: Mutations::User::ResetPassword
    field :send_reset_password_instructions, mutation: Mutations::User::SendResetPasswordInstructions
    field :unlock, mutation: Mutations::User::Unlock
    field :resend_unlock_instructions, mutation: Mutations::User::ResendUnlockInstructions

  end
end
  