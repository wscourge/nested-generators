# frozen_string_literal: true

require 'rails/generators'
require 'generators/service/service_generator'
require 'generator_spec'

RSpec.describe ServiceGenerator, type: :generator do
  describe 'with special characters in method names' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments ['carrot', 'public:peeled?', 'public:smell!', 'private:be_orange']

    before do
      prepare_destination
      run_generator
    end

    it 'renderes "?" and "!" correctly' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'services' do
            file 'carrot_service.rb' do
              contains 'def peeled?'
              contains 'def smell!'
              contains 'private'
              contains 'def be_orange'
            end
          end
        end
        directory 'spec' do
          directory 'services' do
            file 'carrot_service_spec.rb' do
              contains "describe '#peeled?' do"
              contains "describe '#smell!' do"
            end
          end
        end
      })
    end
  end
end
