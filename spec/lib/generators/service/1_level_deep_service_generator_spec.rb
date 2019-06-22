# frozen_string_literal: true

require 'rails/generators'
require 'generators/service/service_generator'
require 'generator_spec'

RSpec.describe ServiceGenerator, type: :generator do
  describe 'with single word' do
    destination File.expand_path('../../../../tmp', __dir__)
    arguments %w[cucumber]

    before do
      prepare_destination
      run_generator
    end

    it 'creates one level deep file structure' do
      expect(destination_root).to(have_structure {
        directory 'app' do
          directory 'services' do
            file 'application_service.rb' do
              contains 'class ApplicationService'
            end
            file 'cucumber_service.rb' do
              contains 'class CucumberService'
            end
          end
        end
        directory 'spec' do
          directory 'services' do
            file 'cucumber_service_spec.rb' do
              contains 'RSpec.describe Services::CucumberService'
            end
          end
        end
      })
    end
  end
end
