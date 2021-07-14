# frozen_string_literal: true

module Types
  # Base type for sorting attributes.
  class SortAttributeEnum < BaseEnum
    value 'id'
    value 'createdAt', value: 'created_at'
    value 'updatedAt', value: 'updated_at'
  end
end
