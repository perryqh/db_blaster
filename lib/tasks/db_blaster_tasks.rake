# frozen_string_literal: true

require 'db_blaster'

namespace :db_blaster do
  desc 'generate table schema'
  task generate_table_schema: :environment do
    schema_name = 'kcp-api-schema.json'
    puts "Generating #{schema_name}......."
    built = DbBlaster::SourceTablesSchemaBuilder.build_schema
    File.open(schema_name, 'w') { |f| f << built.to_json }
    puts 'Success!'
  end
end
