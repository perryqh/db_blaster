# frozen_string_literal: true

module DbBlaster
  # Engine to isolate DbBlaster namespace
  class Engine < ::Rails::Engine
    isolate_namespace DbBlaster

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
