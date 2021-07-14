# frozen_string_literal: true

# Defines abilities for user
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    return if user.new_record?

    if user.superadmin?
      can :access, :rails_admin         # grant access to rails_admin
      can :manage, :all                 # admins can manage all objects
    elsif user.admin?
      can :crud, User, company_id: user.company_id
      can :update, Companies::Company, id: user.company_id
    end
    can :read, Companies::Company, id: user.company_id
    can :read, User, company_id: user.company_id

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
