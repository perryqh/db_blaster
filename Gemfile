# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/peryqh/#{repo}.git" }

gemspec

gem 'brakeman'
# for some reason, github actions 'rubocop-test' was looking at nio4r/.rubocop.yml, which
# is referencing an invalid ruby version
gem 'nio4r', git: 'https://github.com/perryqh/nio4r', branch: 'bump-rubo-target-version'
gem 'panolint'
gem 'pg'
gem 'pry-nav'
gem 'rubocop'
gem 'rubocop-discourse'
gem 'rubocop-rails'
gem 'rubocop-rspec'
gem 'rubycritic', require: false
gem 'simplecov', require: false
