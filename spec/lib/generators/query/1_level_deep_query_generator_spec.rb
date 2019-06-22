# frozen_string_literal: true

require 'rails/generators'
require 'generators/query/query_generator'
require 'generator_spec'

RSpec.describe QueryGenerator, type: :generator do
  describe 'with single word' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments %w[bad_fruits]

    before do
      prepare_destination
      run_generator
    end

    it 'creates one level deep file structure' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'queries' do
            file 'bad_fruits_query.rb' do
              contains 'module Queries'
              contains 'class BadFruitsQuery'
            end
          end
        end
        directory 'spec' do
          directory 'queries' do
            file 'bad_fruits_query_spec.rb' do
              contains 'RSpec.describe Queries::BadFruitsQuery'
            end
          end
        end
      })
    end
  end
end
