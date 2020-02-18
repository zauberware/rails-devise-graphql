class Mutations::User::ResendUnlockInstructions < GraphQL::Schema::Mutation

  null false
  description "Unlock the user account"
  argument :email, String, required: true
  payload_type Boolean

  def resend_unlock_instructions(email:)
    user = User.find_by_email(email)
    return false if !user
    user.resend_unlock_instructions
  end

end