# frozen_string_literal: true

module DbBlaster
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        copy_file 'db_blaster_config.rb', 'config/initializers/db_blaster_config.rb'
      end
    end
  end
end
