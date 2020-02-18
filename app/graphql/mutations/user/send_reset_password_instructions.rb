class Mutations::User::SendResetPasswordInstructions < GraphQL::Schema::Mutation

  null true
  description "Send password reset instructions to users email"
  argument :email, String, required: true
  payload_type Boolean

  def resolve(email:)
    user = User.find_by_email(email)
    return true if !user
    user.send_reset_password_instructions
    true
  end

end