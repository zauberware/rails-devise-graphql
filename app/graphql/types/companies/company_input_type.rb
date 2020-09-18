# frozen_string_literal: true

module Types
  module Companies
    # Attributes to update a company.
    class CompanyInputType < Types::BaseInputObject
      description 'Attributes to update a company.'
      argument :name, String, 'Name of company', required: true
    end
  end
end
