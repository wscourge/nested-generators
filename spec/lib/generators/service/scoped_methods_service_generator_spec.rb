# frozen_string_literal: true

require 'rails/generators'
require 'generators/service/service_generator'
require 'generator_spec'

RSpec.describe ServiceGenerator, type: :generator do
  describe 'scoped methods' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments ['cucumber', 'public:peel', 'protected:smell', 'private:rot']

    before do
      prepare_destination
      run_generator
    end

    it 'creates public, protected and private scopes' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'services' do
            file 'cucumber_service.rb' do
              contains 'def peel'
              contains 'protected'
              contains 'def smell'
              contains 'private'
              contains 'def rot'
            end
          end
        end
        directory 'spec' do
          directory 'services' do
            file 'cucumber_service_spec.rb' do
              contains "describe '#peel' do"
            end
          end
        end
      })
    end
  end
end
