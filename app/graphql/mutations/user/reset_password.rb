class Mutations::User::ResetPassword < GraphQL::Schema::Mutation

  null true
  description "Set the new password"
  argument :password, String, required: true
  argument :passwordConfirmation, String, required: true
  argument :resetPasswordToken, String, required: true
  payload_type Boolean

  def resolve(password:, password_confirmation:, reset_password_token:)
    user = User.with_reset_password_token(reset_password_token)
    return false if !user
    user.reset_password(password, password_confirmation)
  end  

end