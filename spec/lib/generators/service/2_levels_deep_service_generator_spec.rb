# frozen_string_literal: true

require 'rails/generators'
require 'generators/service/service_generator'
require 'generator_spec'

RSpec.describe ServiceGenerator, type: :generator do
  describe 'with slash separated words' do
    destination File.expand_path('../../../../tmp', __dir__)

    arguments ['vegetables/tomato']

    before do
      prepare_destination
      run_generator
    end

    it 'creates two levels deep file structure' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'services' do
            file 'application_service.rb' do
              contains 'module Services'
              contains 'class ApplicationService'
            end
            directory 'vegetables' do
              file 'tomato_service.rb' do
                contains 'module Services'
                contains 'module Vegetables'
                contains 'class TomatoService'
              end
            end
          end
        end
        directory 'spec' do
          directory 'services' do
            directory 'vegetables' do
              file 'tomato_service_spec.rb' do
                contains 'RSpec.describe Services::Vegetables::TomatoService'
              end
            end
          end
        end
      })
    end
  end
end
