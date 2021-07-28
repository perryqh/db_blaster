# frozen_string_literal: true

require_relative 'lib/db_blaster/version'

Gem::Specification.new do |spec|
  spec.name = 'db_blaster'
  spec.version = DbBlaster::VERSION
  spec.authors = ['Perry Hertler']
  spec.email = ['perry@hertler.org']
  spec.homepage = 'https://github.com/perryqh/db_blaster'
  spec.summary = 'Push db changes to AWS SNS.'
  spec.description = 'Push db changes to AWS SNS.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/perryqh/db_blaster'
  spec.metadata['changelog_uri'] = 'https://github.com/perryqh/db_blaster/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'aws-sdk-sns'
  spec.add_dependency 'rails'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'shoulda-matchers'
end
