# frozen_string_literal: true

module DeviseHelper
  def login_user(user = nil)
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = user || create(:user)
      # user.confirm!
      # or set a confirmed_at inside the factory.
      # Only necessary if you are using the "confirmable" module
      sign_in @current_user
    end
  end
end
