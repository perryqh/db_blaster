# frozen_string_literal: true

# Engine to isolate DbBlaster namespace
module DbBlaster
  class Engine < ::Rails::Engine
    isolate_namespace DbBlaster

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
