# frozen_string_literal: true

require 'generators/nested_generators_base_generator'

class ServiceGenerator < NestedGeneratorsBaseGenerator
  source_root File.expand_path('templates', __dir__)

  def initialize(*args, &block)
    super
    @type = 'service'
  end

  def create_service_file
    create_base
    create_class_file
    create_class_spec_file
  end
end
