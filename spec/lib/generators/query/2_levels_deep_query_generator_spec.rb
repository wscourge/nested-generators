# frozen_string_literal: true

require 'rails/generators'
require 'generators/query/query_generator'
require 'generator_spec'

RSpec.describe QueryGenerator, type: :generator do
  describe 'with slash separated words' do
    destination File.expand_path('../../../../tmp', __dir__)

    arguments ['expandables/jackets']

    before do
      prepare_destination
      run_generator
    end

    it 'creates two levels deep file structure' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'queries' do
            directory 'expandables' do
              file 'jackets_query.rb' do
                contains 'module Queries'
                contains 'module Expandables'
                contains 'class JacketsQuery'
              end
            end
          end
        end
        directory 'spec' do
          directory 'queries' do
            directory 'expandables' do
              file 'jackets_query_spec.rb' do
                contains 'RSpec.describe Queries::Expandables::JacketsQuery'
              end
            end
          end
        end
      })
    end
  end
end
