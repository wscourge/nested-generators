# frozen_string_literal: true

require 'rails/generators/base'

class NestedGeneratorsBaseGenerator < Rails::Generators::NamedBase
  SCOPES = %w[public protected private].freeze
  RETURN = '
'
  argument :methods, type: :array,
                     default: [],
                     banner: 'public:method "protected:method?" "private:method!"'

  private

  def create_base
    return if base?

    template 'base_class_template.erb', base_file_path
  end

  def create_class_file
    template 'class_template.erb', class_file_path
  end

  def create_class_spec_file
    template 'class_spec_template.erb', class_spec_file_path
  end

  def base?
    File.exist?(base_file_path)
  end

  def base_file_path
    @base_file_path ||= "app/#{@type.pluralize}/application_#{@type}.rb"
  end

  def class_file_path
    "#{(%w[app] + modules.map(&:underscore)).join('/')}/#{class_file_name}.rb"
  end

  def class_spec_file_path
    "#{(%w[spec] + modules.map(&:underscore)).join('/')}/#{class_file_name}_spec.rb"
  end

  def class_file_name
    @class_file_name ||= "#{last_part.underscore}_#{@type}"
  end

  def last_part
    @last_part ||= class_name.split('::')[-1]
  end

  def modules
    @modules ||= [@type.pluralize.capitalize] + class_name.split('::')[0..-2]
  end

  def open_modules_nesting
    modules.each.with_index.map { |namespace, index| "#{indent * index}module #{namespace}" }.join(RETURN)
  end

  def close_modules_nesting
    modules.each.with_index.map { |_namespace, index| "#{indent * index}end" }.reverse.join(RETURN)
  end

  def open_class
    "#{RETURN}#{class_indent}class #{last_part}#{@type.capitalize}" + (base? ? " < Application#{@type.capitalize}" : '')
  end

  def end_class
    "#{class_indent}end#{RETURN}"
  end

  def class_indent
    @class_indent ||= indent * modules.length
  end

  def code_indent
    @code_indent ||= indent * (modules.length + 1)
  end

  def indent
    @indent ||= '  '
  end

  def in_scope?(method, name)
    " #{method.split(':')&.[](0)} " == " #{name} "
  end

  def scope?(name)
    methods&.any? { |method| in_scope?(method, name) }
  end

  def scope_methods(name)
    methods&.select { |method| in_scope?(method, name) }&.map(&:strip)
  end

  def strip_scope(method, name)
    method.gsub("#{name}:", '')
  end

  def rspec_empty_message(method = nil)
    "pending 'add some examples to (or delete) #{class_spec_file_path}#{method.nil? ? '' : ('#' + method)}'"
  end
end
