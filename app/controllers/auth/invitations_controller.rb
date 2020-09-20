# frozen_string_literal: true

module Auth
  # Custom passwords controller
  class InvitationsController < Devise::InvitationsController
    # GET /resource/invitation/accept?invitation_token=abcdef
    # redirect user to front end to finish invitation
    def edit
      redirect_to "http://#{ENV['CLIENT_URL']}/users/invitation/accept?invitation_token=#{params[:invitation_token]}"
    end
  end
end
