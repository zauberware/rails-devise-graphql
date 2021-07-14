# frozen_string_literal: true

module Types
  # Enum for the sort direction
  class SortDirectionEnum < BaseEnum
    value 'asc', value: 'asc'
    value 'desc', value: 'desc'
  end
end
