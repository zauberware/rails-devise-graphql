# frozen_string_literal: true

module SearchAndFilterModule
  extend ActiveSupport::Concern

  ALLOWED_BOOLEAN_FILTERS = [true, false].freeze
  ALLOWED_UUID_FILTERS = %w[id user_id case_id customer_id agent_id creator_id policyholder_id conflict_partner_id project_id record_id
                            case_creator_id case_policy_holder_id case_conflict_partner_id].freeze

  module ClassMethods
    # override in your resolver to allow order by attributes
    def allowed_filter_attributes
      raise 'Not implemented'
    end

    # apply_filter recursively loops through "OR" branches
    def apply_filter(scope, value)
      branches = normalize_filters(scope, value).reduce { |a, b| a.or(b) }
      scope.merge branches
    end

    # apply sort_by
    def apply_sort_by(scope, value)
      direction = 'asc'
      if value[:attribute].present?
        direction = value[:direction] if value[:direction].present? && %w[asc desc].include?(value[:direction].downcase)
        # do not use table name if the attribute contains :
        # used for relations and methods
        table = value[:attribute].to_s.include?(':') ? '' : "#{scope.model.table_name}."
        scope = scope.order("#{table}#{value[:attribute].delete(':')} #{direction}")
      end
      scope
    end

    def search_and_filter(resources, filter, sort_by)
      @resources = resources
      @resources = apply_filter(@resources, filter) if filter
      @resources = apply_sort_by(@resources, sort_by) if sort_by
      @resources
    end

    def text_search(query)
      if query.present?
        search_text = columns.select { |a| [:string].include? a.type }.map { |a| "#{a.name} ilike :q" }
        where(search_text.join(' OR '), q: "%#{query}%")
      else
        all
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def normalize_filters(scope, value, branches = [])
      allowed_filter_attributes.each do |filter_attr|
        # HACK: for related relations?!
        column_name = filter_attr.gsub('case_policyholder_', 'customers.')
        column_name = column_name.gsub('agent_', 'users.') unless column_name.include?('agent_ids')
        column_name = column_name.gsub('case_project_', 'projects.')
        column_name = column_name.gsub('case_', 'm2_cases.')
        column_name = "#{table_name}.#{column_name}" unless column_name.include?('.')

        if filter_attr == 'text_search' && value[filter_attr.to_sym].present?
          # make a text search
          scope = scope.text_search(value[filter_attr.to_sym])
        elsif ALLOWED_BOOLEAN_FILTERS.include?(value[filter_attr.to_sym])
          scope = scope.where(column_name => value[filter_attr.to_sym])
        elsif value[filter_attr.to_sym].present? && value[filter_attr.to_sym].instance_of?(String) &&
              value[filter_attr.to_sym].start_with?('<', '>')
          split_date_value = value[filter_attr.to_sym].split(' ', 2)
          filter_attr = filter_attr.gsub('_start', '').gsub('_end', '')
          column_name = filter_attr.gsub('case_', 'm2_cases.')
          scope = scope.where("#{column_name} #{split_date_value[0]} ?", split_date_value[1].to_datetime)
        elsif value[filter_attr.to_sym].present? && value[filter_attr.to_sym].instance_of?(String) &&
              ALLOWED_UUID_FILTERS.include?(filter_attr.to_s)
          scope = scope.where("#{column_name} = ?", value[filter_attr.to_sym])
        elsif value[filter_attr.to_sym].present? && value[filter_attr.to_sym].instance_of?(String)
          scope = scope.where("#{column_name} LIKE ?", "%#{value[filter_attr.to_sym]}%")
        elsif value[filter_attr.to_sym].present? && value[filter_attr.to_sym].instance_of?(Integer)
          scope = scope.where("#{column_name} = ?", value[filter_attr.to_sym])
        elsif value[filter_attr.to_sym].present? && value[filter_attr.to_sym].instance_of?(Array)
          scope = scope.where(column_name.to_s[0..-2] => value[filter_attr.to_sym])
        end
      end
      branches << scope
      branches
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
