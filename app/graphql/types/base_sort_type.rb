# frozen_string_literal: true

module Types
  # Base type for sorting objects
  class BaseSortType < BaseInputObject
    argument :direction, ::Types::SortDirectionEnum, required: true, description: 'Set a direction with "asc" or "desc".'
    argument :attribute, ::Types::SortAttributeEnum, required: true, description: 'Choose the column to sort the resource.'
    # override argument :attribute in your subclass
  end
end
