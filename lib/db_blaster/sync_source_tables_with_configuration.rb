module DbBlaster
  # Update the db-blaster source tables based on provided configuration
  module SyncSourceTablesWithConfiguration
    def self.sync
      SourceTable.sync(SourceTableConfigurationBuilder
                         .build_all(DbBlaster.configuration))
    end
  end
end