# frozen_string_literal: true

module Types
  # Base type for sort objects
  class ItemOrderType < BaseInputObject
    argument :attribute, String, required: true, description: 'The attribute you want to order by.'
    argument :direction, String, required: true, description: 'Set a direction with "asc" or "desc".'
  end
end
