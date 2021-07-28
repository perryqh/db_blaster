# frozen_string_literal: true

# Represents tables that should be synced
module DbBlaster
  class SourceTable < ApplicationRecord
    include Sync

    validates :name, uniqueness: { case_sensitive: false }, presence: true
  end
end
