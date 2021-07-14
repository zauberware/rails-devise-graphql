# frozen_string_literal: true

module Resolvers
  module Users
    # Custom SORTING
    class UserSortEnum < ::Types::SortAttributeEnum
      value 'id', value: 'id'
      value 'role', value: 'role'
      value 'firstname', value: 'firstname'
      value 'lastname', value: 'lastname'
      value 'email', value: 'email'
    end

    # Sort Type Enum
    class UserSortType < ::Types::BaseSortType
      argument :attribute, UserSortEnum, required: true, description: 'Choose the column to sort the resource.'
    end

    # FILTERS
    # inline input type definition for the advanced filter
    class UserFilterType < ::Types::BaseInputObject
      argument :OR, [self], required: false
      argument :text_search, String, required: false
      argument :firstname, String, required: false
      argument :lastname, String, required: false
      argument :email, String, required: false
      argument :created_at, String, required: false
      argument :updated_at, String, required: false
    end

    # Resolver to return Users
    class Users < Resolvers::BaseResolver
      description 'Returns all Users'
      type Types::Users::UserType.collection_type, null: false
      argument :page, Integer, required: false
      argument :limit, Integer, required: false
      argument :sort_by, UserSortType, required: false
      argument :filter, UserFilterType, required: false

      def resources
        raise CanCan::AccessDenied, 'access denied' if context[:current_user].nil?

        ::User.accessible_by(current_ability)
      end

      def resolve(filter: nil, sort_by: nil, page: 1, limit: 100)
        @resources = resources.search_and_filter(resources, filter, sort_by)
        @resources = @resources.page(page).per(limit)
        @resources
      end
    end
  end
end
