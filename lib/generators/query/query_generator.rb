# frozen_string_literal: true

require 'generators/nested_generators_base_generator'

class QueryGenerator < NestedGeneratorsBaseGenerator
  source_root File.expand_path('templates', __dir__)

  def initialize(*args, &block)
    super
    @type = 'query'
  end

  def create_query_file
    create_class_file
    create_class_spec_file
  end
end
