# frozen_string_literal: true

require_relative 'lib/rails_band/version'

Gem::Specification.new do |spec|
  spec.name        = 'rails_band'
  spec.version     = RailsBand::VERSION
  spec.authors     = ['Yutaka Kamei']
  spec.email       = ['kamei@yykamei.me']
  spec.homepage    = 'https://github.com/yykamei/rails_band'
  spec.summary     = 'Easy-to-use Rails Instrumentation API'
  spec.description = 'A Rails plugin to facilitate the use of Rails Instrumentation API.'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/yykamei/rails_band/blob/main/CHANGELOG.md'

  spec.files = Dir['lib/**/*', 'LICENSE', 'Rakefile', 'README.md']

  spec.required_ruby_version = '>= 2.6'
  spec.add_dependency 'rails', '>= 6.0'
end
