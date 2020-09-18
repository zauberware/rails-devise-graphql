# frozen_string_literal: true

module Mutations
  module Companies
    # Updates an existing company.
    class UpdateCompany < Mutations::BaseMutation
      description 'Updates an existing company.'
      argument :id, ID, required: true
      argument :attributes, Types::Companies::CompanyInputType, required: true
      payload_type Types::Companies::CompanyType

      def resolve(id:, attributes:)
        # find company
        company = ::Companies::Company.accessible_by(current_ability).find_by(id: id)
        if company.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::Companies::Company.model_name.human)
        end

        company.attributes = attributes.to_h
        current_ability.authorize! :update, company
        return company if company.save!
      end
    end
  end
end
