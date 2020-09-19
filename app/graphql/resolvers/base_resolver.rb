# frozen_string_literal: true

module Resolvers
  # Base resolver class include everything you need for sorting and filtering entities
  class BaseResolver < GraphQL::Schema::Resolver
    # override in your resolver to allow order by attributes
    def allowed_filter_attributes
      raise 'Return an array with your allowed filter attributes.'
    end

    # apply_filter recursively loops through "OR" branches
    def apply_filter(scope, value)
      branches = normalize_filters(value).reduce { |a, b| a.or(b) }
      scope.merge branches
    end

    def normalize_filters(value, branches = [])
      scope = resources
      allowed_filter_attributes.each do |filter_attr|
        if value[filter_attr.to_sym].present?
          scope = scope.where("#{filter_attr} LIKE ?", "%#{value[filter_attr.to_sym]}%")
        end
      end
      branches << scope
      value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?
      branches
    end

    # override in your resolver to allow order by attributes
    def allowed_order_attributes
      raise 'Return an array with your allowed order attributes.'
    end

    # apply order_by
    def apply_order_by(scope, value)
      direction = 'asc'
      if value[:attribute].present? &&
         allowed_order_attributes.include?(value[:attribute])
        direction = value[:direction] if value[:direction].present? && %w[asc desc].include?(value[:direction].downcase)
        scope = scope.order("#{value[:attribute]} #{direction}")
      end
      scope
    end

    def current_ability
      Ability.new(context[:current_user])
    end
  end
end
