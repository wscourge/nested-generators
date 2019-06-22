# frozen_string_literal: true

require 'rails/generators'
require 'generators/query/query_generator'
require 'generator_spec'

RSpec.describe QueryGenerator, type: :generator do
  describe 'scoped methods' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments ['carrots', 'public:fresh', 'protected:peel', 'private:skip']

    before do
      prepare_destination
      run_generator
    end

    it 'creates public, protected and private scopes' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'queries' do
            file 'carrots_query.rb' do
              contains 'def fresh'
              contains 'protected'
              contains 'def peel'
              contains 'private'
              contains 'def skip'
            end
          end
        end
        directory 'spec' do
          directory 'queries' do
            file 'carrots_query_spec.rb' do
              contains "describe '#fresh' do"
            end
          end
        end
      })
    end
  end
end
