# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name                 = 'nested-generators'
  spec.version              = '0.0.0'
  spec.date                 = '2019-06-22'
  spec.authors              = ['wscourge']
  spec.email                = ['wscourge@gmail.com']
  spec.summary              = 'Nested generators'
  spec.description          = 'A handful of rails generate scripts'
  spec.homepage             = 'https://github.com/wscourge/nested-generators'
  spec.license              = 'MIT'
  spec.files                = Dir.glob('{lib}/**/*')
  spec.require_path         = 'lib'
  spec.post_install_message = 'Thanks for installing! See rails generate service --help for usage'
  spec.add_development_dependency 'rails', '~> 5.2.2'
end
