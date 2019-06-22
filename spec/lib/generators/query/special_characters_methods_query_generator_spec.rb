# frozen_string_literal: true

require 'rails/generators'
require 'generators/query/query_generator'
require 'generator_spec'

RSpec.describe QueryGenerator, type: :generator do
  describe 'with special characters in method names' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments ['potato', 'public:peeled?', 'public:peel!', 'private:rotten?']

    before do
      prepare_destination
      run_generator
    end

    it 'renderes "?" and "!" correctly' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'queries' do
            file 'potato_query.rb' do
              contains 'def peeled?'
              contains 'def peel!'
              contains 'private'
              contains 'def rotten?'
            end
          end
        end
        directory 'spec' do
          directory 'queries' do
            file 'potato_query_spec.rb' do
              contains "describe '#peeled?' do"
              contains "describe '#peel!' do"
            end
          end
        end
      })
    end
  end
end
