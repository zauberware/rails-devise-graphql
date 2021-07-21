# frozen_string_literal: true

module Mutations
  module Companies
    # Updates an existing company.
    class UpdateCompany < Mutations::UpdateMutationBase
      description 'Updates an existing m2 case.'
      argument :attributes, Types::Companies::CompanyInputType, required: true
      payload_type Types::Companies::CompanyType

      protected

      def resources
        ::Companies::Company.accessible_by(current_ability)
      end
    end
  end
end
