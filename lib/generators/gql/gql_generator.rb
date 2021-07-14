# frozen_string_literal: true

class GqlGenerator < Rails::Generators::NamedBase
  desc 'Create graphql files for model'
  source_root File.expand_path('templates', __dir__)

  argument :name, type: :string
  argument :modes, type: :string

  def initialize(args, *options) #:nodoc:
    # Unfreeze name in case it's given as a frozen string
    args[0] = args[0].dup if args[0].is_a?(String) && args[0].frozen?
    super

    assign_names!(name)
  end

  def create_input_type_file
    return unless modes.include?('c') || modes.include?('u')

    template 'input_type.rb', File.join('app/graphql/types', @class_name.pluralize.underscore, "#{@class_name.underscore}_input_type.rb")
  end

  def create_type_file
    template 'type.rb', File.join('app/graphql/types', @class_name.pluralize.underscore, "#{@class_name.underscore}_type.rb")
  end

  def add_space_in_query_file
    return unless modes.include? 'r'

    sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'query_type.rb'),
                     " \n",
                     after: sentinel, verbose: false, force: false
  end

  def create_detail_file
    return unless modes.include? 'r'

    template 'detail.rb', File.join('app/graphql/resolvers', @class_name.pluralize.underscore, "#{@class_name.underscore}.rb")
    template 'detail_spec.rb', File.join('spec/graphql/resolvers', @class_name.pluralize.underscore, "#{@class_name.underscore}_spec.rb")

    sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'query_type.rb'),
                     "    field :#{@class_name.underscore}, resolver: Resolvers::#{@class_name.pluralize}::#{@class_name}\n",
                     after: sentinel, verbose: false, force: false
  end

  def create_list_file
    return unless modes.include? 'r'

    template 'list.rb', File.join('app/graphql/resolvers', @class_name.pluralize.underscore, "#{@class_name.pluralize.underscore}.rb")
    template 'list_spec.rb',
             File.join('spec/graphql/resolvers', @class_name.pluralize.underscore, "#{@class_name.pluralize.underscore}_spec.rb")

    sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'query_type.rb'),
                     "    field :#{@class_name.pluralize.underscore}, "\
                     "resolver: Resolvers::#{@class_name.pluralize}::#{@class_name.pluralize}\n",
                     after: sentinel, verbose: false, force: false

    search_attr_str = class_attributes.map(&:name).join(' ')

    model_sentinel = /class .*#{@class_name}\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/models/', "#{@class_name.underscore}.rb"),
                     "  include SearchAndFilterModule\n\n"\
                     "  def self.allowed_filter_attributes\n"\
                     "    %w[text_search #{search_attr_str}]\n"\
                     "  end\n\n",
                     after: model_sentinel, verbose: false, force: false
  end

  def add_section_in_query_file
    return unless modes.include? 'r'

    sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'query_type.rb'),
                     "    # #{@class_name.pluralize}\n",
                     after: sentinel, verbose: false, force: false
  end

  def add_space_in_mutation_file
    return unless modes.include?('u') || modes.include?('c') || modes.include?('d')

    sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'mutation_type.rb'),
                     " \n",
                     after: sentinel, verbose: false, force: false
  end

  def create_create_file
    return unless modes.include? 'c'

    template 'create.rb', File.join('app/graphql/mutations', @class_name.pluralize.underscore, "create_#{@class_name.underscore}.rb")
    template 'create_spec.rb',
             File.join('spec/graphql/mutations', @class_name.pluralize.underscore, "create_#{@class_name.underscore}_spec.rb")

    sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'mutation_type.rb'),
                     "    field :create_#{@class_name.underscore}, "\
                     "mutation: Mutations::#{@class_name.pluralize}::Create#{@class_name}\n",
                     after: sentinel, verbose: false, force: false
  end

  def create_delete_file
    return unless modes.include? 'd'

    template 'delete.rb', File.join('app/graphql/mutations', @class_name.pluralize.underscore, "delete_#{@class_name.underscore}.rb")
    template 'delete_spec.rb',
             File.join('spec/graphql/mutations', @class_name.pluralize.underscore, "delete_#{@class_name.underscore}_spec.rb")

    sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'mutation_type.rb'),
                     "    field :delete_#{@class_name.underscore}, "\
                     "mutation: Mutations::#{@class_name.pluralize}::Delete#{@class_name}\n",
                     after: sentinel, verbose: false, force: false
  end

  def create_update_file
    return unless modes.include? 'u'

    template 'update.rb', File.join('app/graphql/mutations', @class_name.pluralize.underscore, "update_#{@class_name.underscore}.rb")
    template 'update_spec.rb',
             File.join('spec/graphql/mutations', @class_name.pluralize.underscore, "update_#{@class_name.underscore}_spec.rb")

    sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'mutation_type.rb'),
                     "    field :update_#{@class_name.underscore}, "\
                     "mutation: Mutations::#{@class_name.pluralize}::Update#{@class_name}\n",
                     after: sentinel, verbose: false, force: false
  end

  def add_section_in_mutation_file
    return unless modes.include?('u') || modes.include?('c') || modes.include?('d')

    sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
    inject_into_file File.join('app/graphql/types', 'mutation_type.rb'),
                     "    # #{@class_name.pluralize}\n",
                     after: sentinel, verbose: false, force: false
  end

  attr_reader :class_name, :class_attributes

  private

  def assign_names!(name)
    @class_name = name.singularize.camelize
    @class_attributes = @class_name.classify.constantize.columns
  end
end
