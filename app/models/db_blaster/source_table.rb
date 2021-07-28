# frozen_string_literal: true

# represents all tables that should be synced
module DbBlaster
  class SourceTable < ApplicationRecord
    validates :name, uniqueness: { case_sensitive: false }, presence: true

    # Syncs configuration tables with db
    # Consider moving towards ActiveRecord::Base.connection.tables in the future
    def self.sync(table_configs)
      SourceTable.where.not(name: table_configs.collect { |tc| tc[:name] }).delete_all

      table_configs.each do |config|
        source_table = SourceTable.where(name: config[:name]).first_or_create
        source_table.update!(config)
      end
    end
  end
end
